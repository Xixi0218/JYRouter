//
//  YJYRouterParameters.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/22.
//

import UIKit
/// 保存路由时发下的动态路径组件
/// 在这个结构已经被参数值填充后，你可以get方式获取
public class YJYRouterParameters {
    
    /// 存储 `catchall` (`**`) 匹配的组件。
    private struct Catchall {
        var values: [String] = []
        var isPercentEncoded: Bool = true
    }
    
    private var values: [String: String]
    private var catchall: Catchall
    
    public init() {
        self.values = [:]
        self.catchall = Catchall()
    }
    
    /// 从参数包中获取命名参数。
    ///
    /// 例如获取bimart://comments/:comment_id
    /// 将使用以下方法获取：
    ///
    /// 让commentID = parameters.get("comment_id")
    ///
    public func get(_ name: String) -> String? {
        self.values[name]
    }
    
    /// 从参数包中获取命名参数。
    ///
    /// 例如获取bimart://comments/:comment_id
    /// 将使用以下方法获取：
    ///
    /// 让commentID = parameters.get("comment_id", as: Int.self)
    ///
    public func get<T>(_ name: String, as type: T.Type = T.self) -> T? where T: LosslessStringConvertible {
        self.get(name).flatMap(T.init)
    }
    
    /// 向包中添加一个新的参数值。
    public func set(_ name: String, to value: String?) {
        self.values[name] = value?.removingPercentEncoding
    }
    
    /// 获取 `catchall` (`**`) 匹配的组件。
    /// 如果路由没有命中 `catchall`，它将返回 `[]`。
    public func getCatchall() -> [String] {
        if self.catchall.isPercentEncoded {
            self.catchall.values = self.catchall.values.map { $0.removingPercentEncoding ?? $0 }
            self.catchall.isPercentEncoded = false
        }
        return self.catchall.values
    }
    
    /// 设置 `catchall` (`**`) 匹配的组件。
    public func setCatchall(matched: [String]) {
        self.catchall = Catchall(values: matched)
    }
}
