//
//  YJYRouterString+Extension.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/17.
//

import Foundation

extension String {
    /// 获取url的参数
    public var bm_queryParameters: [String: Any] {
        var parameters = [String: Any]()
        guard let urlComponents = NSURLComponents(string: self), let queryItems = urlComponents.queryItems else {
            return parameters
        }
        queryItems.forEach({ (item) in
            if let existValue = parameters[item.name], let value = item.value {
                if var existValue = existValue as? [Any] {
                    existValue.append(value)
                } else {
                    parameters[item.name] = [existValue, value]
                }
            } else {
                parameters[item.name] = item.value
            }
        })
        return parameters
    }
    
}

extension URL {
    
    public var bm_fullRoute: String {
        var resultScheme = ""
        if let scheme = scheme {
            resultScheme = "\(scheme)://"
        }
        return resultScheme + (host ?? "") + path
    }
    
    /// 包含host的path字符串
    public var bm_path: String {
        return (host ?? "") + path
    }
    
    /// 分割包含host的path字符串
    public var bm_paths: [String] {
        return bm_path.split(separator: "/").map{ String.init($0) }
    }
    
    /// 分割包含host的path字符串生成对应PathComponent
    public var bm_pathComponents: [YJYRouterPathComponent] {
        return bm_path.split(separator: "/").map { .init(stringLiteral: .init($0)) }
    }
    
}
