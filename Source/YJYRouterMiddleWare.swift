//
//  YJYRouterMiddleWare.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/16.
//

import UIKit

/// 路由插件,用于偶尔可能在请求之前检测登录状态
public protocol YJYRouterMiddleWare {
    
    /// 即将在路由发生之前进行抛错中断
    func willRoute<T: YJYRouterReuqest>(_ request: T) throws
    
}
