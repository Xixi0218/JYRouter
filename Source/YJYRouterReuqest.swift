//
//  YJYRouterReuqest.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/16.
//

import UIKit

/// 路由请求体
public protocol YJYRouterReuqest {
    
    associatedtype Response
    /// 请求体对应的url
    static var url: String { get }
    /// 根据url和url的参数生成对应请求体
    static func decode(from url: URL, urlParameters: YJYRouterParameters, queryParams: [String: Any], context: Any?) -> Self
    
}
