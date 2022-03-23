//
//  YJYRouter.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/16.
//

import UIKit

public typealias YJYRequestHandler<T: YJYRouterReuqest> = (T) throws -> T.Response
public typealias YJYURLRequestHandler = (URL, YJYRouterParameters, Any?) throws -> Any
public typealias YJYAnyRequestHandler = (Any) throws -> Any

public class YJYRouter {
    
    public enum ActionType {
        case push
        case present
    }
    
    /// 多读单写线程
    private let queue = DispatchQueue(label: "com.bitmart.router", attributes: .concurrent)
    
    ///单例对象
    public static let `default`: YJYRouter = YJYRouter()
    
    /// request对应一个handler
    private var requestHandleMap: [ObjectIdentifier: YJYAnyRequestHandler] = [:]
    
    ///  解析url的数
    private let rootNode = YJYRouterNode()
    
    /// 注册路由
    /// - Parameters:
    ///   - type: 遵守YJYRouterReuqest的对象
    ///   - middleWares: 中间件
    ///   - handler: 响应事件
    public func resgister<T: YJYRouterReuqest>(_ type: T.Type, use middleWares: [YJYRouterMiddleWare] = [], handler: @escaping YJYRequestHandler<T>) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.requestHandleMap[ObjectIdentifier(type)] = { request in
                if let request = request as? T {
                    for middleWare in middleWares {
                        try middleWare.willRoute(request)
                    }
                    return try handler(request)
                }
                throw YJYRouterError.notResigter
            }
            let urlHandler: YJYURLRequestHandler = { url, parameter, context in
                let request = T.decode(from: url, urlParameters: parameter, queryParams: url.absoluteString.bm_queryParameters, context: context)
                for middleWare in middleWares {
                    try middleWare.willRoute(request)
                }
                return try handler(request)
            }
            if let validUrl = URL(string: T.url) {
                self.rootNode.register(urlHandler, at: validUrl.bm_pathComponents)
            } else {
                assertionFailure("无效的url")
            }
        }
    }
    
    
    /// 根据identifier获取handler
    /// - Parameter identifier: 唯一表示符号，由类对象生成
    /// - Returns: 返回一个handler
    private func getRequestHandlerByIdentifier(identifier: ObjectIdentifier) -> YJYAnyRequestHandler? {
        var resolver: YJYAnyRequestHandler?
        queue.sync {
            guard let tempResolver = requestHandleMap[identifier] else {
                return
            }
            resolver = tempResolver
        }
        return resolver
    }
    
    
    /// 根据path获取树中对应节点下的handler和信息
    /// - Parameter path: url的path字符串
    /// - Returns: 返回handler和parameters
    private func getUrlHandlerByPath(path: [String]) -> (handle: YJYURLRequestHandler?, parameters: YJYRouterParameters) {
        var parameters = YJYRouterParameters()
        var handle: YJYURLRequestHandler?
        queue.sync {
            handle = rootNode.route(path: path, parameters: &parameters)
        }
        return (handle, parameters)
    }
    
    /// 根据request发起路由请求
    /// - Parameters:
    ///   - request: 本地定义的请求体
    /// - Returns: 返回一个响应体
    public func request<T: YJYRouterReuqest>(request: T) throws -> T.Response {
        let resolver = getRequestHandlerByIdentifier(identifier: ObjectIdentifier(T.self))
        if let result = try resolver?(request) as? T.Response {
            return result
        }
        throw YJYRouterError.requestError
    }
    
    /// 根据url发起路由请求
    /// - Parameters:
    ///   - url: 远程地址
    ///   - context: 为解决部分无法通过url传参
    /// - Returns: 返回一个响应体
    public func request(url: URL, context: Any? = nil) throws -> Any {
        let result = getUrlHandlerByPath(path: url.bm_paths)
        if let handle = result.handle {
            return try handle(url, result.parameters, context)
        }
        return YJYRouterError.requestError
    }
    
    
    @discardableResult
    /// 直接push路由表的vc并返回
    /// - Parameters:
    ///   - request: 请求对象
    ///   - actionType: 转场动画类型
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成回调
    /// - Returns: 返回路由表里对应vc
    public func open<T: YJYRouterReuqest>(request: T,
                                         context: Any? = nil,
                                         actionType: ActionType = .push,
                                         animated: Bool = true,
                                         completion: (() -> Void)? = nil) -> T.Response? where T.Response: UIViewController {
        if let result = try? self.request(request: request) {
            action(vc: result, actionType: actionType, animated: animated, completion: completion)
            return result
        }
        return nil
    }
    
    @discardableResult
    /// 直接push路由表的vc并返回
    /// - Parameters:
    ///   - url: 路由表中的url
    ///   - context: 为解决部分无法通过url传参
    ///   - actionType: 转场动画类型
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成回调
    /// - Returns: 返回路由表里对应vc
    public func open(url: URL,
                     context: Any? = nil,
                     actionType: ActionType = .push,
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) -> UIViewController? {
        if let result = try? self.request(url: url, context: context) as? UIViewController {
            action(vc: result, actionType: actionType, animated: animated, completion: completion)
            return result
        }
        return nil
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
    
}
