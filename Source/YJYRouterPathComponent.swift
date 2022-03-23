//
//  YJYRouterPathComponent.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/22.
//

import UIKit

/// 路由的路径组件
public enum YJYRouterPathComponent: ExpressibleByStringInterpolation, CustomStringConvertible {
    
    /// 一个普通的路径组件
    case constant(String)
    
    /// 动态参数组件
    /// 表示为`:`后面跟标识符
    case parameter(String)
    
    ///  通配符
    ///  表示为`*`
    case anything
    
    ///  将匹配一个或多个`*`的组件
    ///  表示为`**`
    case catchall
    
    public init(stringLiteral value: String) {
        if value.hasPrefix(":") {
            self = .parameter(.init(value.dropFirst()))
        } else if value == "*" {
            self = .anything
        } else if value == "**" {
            self = .catchall
        } else {
            self = .constant(value)
        }
    }
    
    public var description: String {
        switch self {
        case .anything:
            return "*"
        case .catchall:
            return "**"
        case .parameter(let name):
            return ":" + name
        case .constant(let constant):
            return constant
        }
    }
}

extension Sequence where Element == YJYRouterPathComponent {
    public var string: String {
        return self.map(\.description).joined(separator: "/")
    }
}
