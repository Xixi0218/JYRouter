//
//  YJYRouter.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/16.
//

import UIKit

public typealias YJYURLRequestHandler = ([String: Any], YJYRouterParameters) throws -> Any

public class YJYRouter {
    
    public enum ActionType {
        case push
        case present
    }
    
    /// 多读单写线程
    private let queue = DispatchQueue(label: "com.bitmart.router", attributes: .concurrent)
    
    ///单例对象
    public static let `default`: YJYRouter = YJYRouter()
    
    ///  解析url的数
    private let rootNode = YJYRouterNode()
    
    /// 注册路由
    /// - Parameters:
    ///   - type: 遵守YJYRouterReuqest的对象
    ///   - middleWares: 中间件
    ///   - handler: 响应事件
    public func resgister(_ pattern: YJYRouterURLConvertible,
                          use middleWares: [YJYRouterMiddleWare]? = nil,
                          handler: @escaping YJYURLRequestHandler) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let validUrl = pattern.yjy_url {
                let urlHandler: YJYURLRequestHandler = { queryItems, parameter in
                    return try handler(queryItems, parameter)
                }
                self.rootNode.register(urlHandler, middleWares: middleWares, at: validUrl.yjy_pathComponents)
            } else {
                assertionFailure("无效的url")
            }
        }
    }
    
    /// 根据url发起路由请求
    /// - Parameters:
    ///   - url: 远程地址
    ///   - params: 路由参数
    /// - Returns: 返回一个响应体
    public func request(_ pattern: YJYRouterURLConvertible,
                        params: [String: Any] = [:],
                        isExcuteMiddleWares: Bool = true) throws -> Any? {
        guard let url = pattern.yjy_url else { throw YJYRouterError.notResigter }
        let result = getUrlHandlerByPath(path: url.yjy_paths)

        // 如果是重定向操作就不执行插件
        if isExcuteMiddleWares {
            try excuteMiddleWares(url: url,middleWares: result.middleWares)
        }

        guard let handle = result.handle else { throw YJYRouterError.requestError }
        var customParams = params
        customParams.merge(url.yjy_queryParameters) { (current, _)  in current }
        return try handle(customParams, result.parameters)
    }
    
    @discardableResult
    /// 直接push路由表的vc并返回
    /// - Parameters:
    ///   - url: 路由表中的url
    ///   - params: 路由参数
    ///   - animated: 是否需要动画
    /// - Returns: 返回路由表里对应vc
    public func push(_ pattern: YJYRouterURLConvertible,
                     params: [String: Any] = [:],
                     animated: Bool = true,
                     isExcuteMiddleWares: Bool = true) -> UIViewController? {
        if let result = try? self.request(pattern, params: params, isExcuteMiddleWares: isExcuteMiddleWares) as? UIViewController {
            action(vc: result, actionType: .push, animated: animated)
            return result
        }
        return nil
    }
    
    @discardableResult
    /// 直接push路由表的vc并返回
    /// - Parameters:
    ///   - url: 路由表中的url
    ///   - params: 路由参数
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成回调
    /// - Returns: 返回路由表里对应vc
    public func present(_ pattern: YJYRouterURLConvertible,
                        params: [String: Any] = [:],
                        animated: Bool = true,
                        isExcuteMiddleWares: Bool = true,
                        completion: (() -> Void)? = nil) -> UIViewController? {
        if let result = try? self.request(pattern, params: params, isExcuteMiddleWares: isExcuteMiddleWares) as? UIViewController {
            action(vc: result, actionType: .present, animated: animated, completion: completion)
            return result
        }
        return nil
    }
    
    /// 根据path获取树中对应节点下的handler和信息
    /// - Parameter path: url的path字符串
    /// - Returns: 返回handler和parameters
    private func getUrlHandlerByPath(path: [String]) -> (handle: YJYURLRequestHandler?, parameters: YJYRouterParameters, middleWares: [YJYRouterMiddleWare]?) {
        var parameters = YJYRouterParameters()
        var handle: YJYURLRequestHandler?
        var middleWares: [YJYRouterMiddleWare]?
        queue.sync {
            (handle, middleWares) = rootNode.route(path: path, parameters: &parameters)
        }
        return (handle, parameters, middleWares)
    }
    
    /// 转场动画
    /// - Parameters:
    ///   - vc: 控制器
    ///   - actionType: 动画类型
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成回调
    private func action(vc:UIViewController,
                        actionType: ActionType = .push,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            switch actionType {
            case .push:
                YJYRouterTool.currentTopViewController()?.navigationController?.pushViewController(vc, animated: animated)
            case .present:
                YJYRouterTool.currentTopViewController()?.present(vc, animated: animated, completion: completion)
            }
            
        }
    }

    private func excuteMiddleWares(url: URL, middleWares: [YJYRouterMiddleWare]?) throws {
        guard let middleWares = middleWares else { return }
        for middleWare in middleWares {
            do {
                try middleWare.willRoute(url.yjy_fullRoute)
            } catch let error as YJYRouterError {
                if case let .redirect(url, action, isExcuteMiddleWares) = error {
                    switch action {
                    case .none:
                        if let object = try? request(url, isExcuteMiddleWares: isExcuteMiddleWares) {
                            throw YJYRouterError.redirectObject(object: object)
                        } else {
                            throw YJYRouterError.notResigter
                        }
                    case .push:
                        if let vc = self.push(url, isExcuteMiddleWares: isExcuteMiddleWares) {
                            throw YJYRouterError.redirectObject(object: vc)
                        } else {
                            throw YJYRouterError.requestError
                        }
                    case .present:
                        if let vc = self.present(url, isExcuteMiddleWares: isExcuteMiddleWares) {
                            throw YJYRouterError.redirectObject(object: vc)
                        } else {
                            throw YJYRouterError.requestError
                        }
                    }
                }
            } catch {
                throw error
            }
        }
    }
}
