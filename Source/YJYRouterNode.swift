//
//  YJYRouterNode.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/22.
//

import UIKit

public final class YJYRouterNode: CustomStringConvertible {
    
    /// 根节点
    private var root: Node
    
    init() {
        self.root = Node()
    }
    
    /// 注册新路由
    /// - Parameters:
    ///   - output: root包含的对象
    ///   - path: 对应path数组
    public func register(_ output:@escaping YJYURLRequestHandler, at path: [YJYRouterPathComponent]) {
        var current = self.root
        for (index, component) in path.enumerated() {
            switch component {
            case .catchall:
                precondition(index == path.count - 1, "路径全部拦截 ('\(component)') 必须在最后一位.")
                fallthrough
            default:
                current = current.buildOrFetchChild(for: component)
            }
        }
        
        if current.output != nil {
            print("[Routing] Warning: 路径出参被覆盖: \(path.string)")
        }
        
        current.output = output
    }
    
    /// 在根节点中找出对应符合路由的节点并收集动态参数
    /// - Parameters:
    ///   - path: url的路径
    ///   - parameters: 收集动态参数的对象
    /// - Returns: 返回对应handler
    public func route(path: [String], parameters: inout YJYRouterParameters) -> YJYURLRequestHandler? {
        var currentNode: Node = self.root
        var currentCatchall: (Node, [String])?
        search: for (index, slice) in path.enumerated() {
            if let catchall = currentNode.catchall {
                currentCatchall = (catchall, [String](path.dropFirst(index)))
            }
        
            if let constant = currentNode.constants[slice.lowercased()] {
                currentNode = constant
                continue search
            }
            
            if let wildcard = currentNode.wildcard {
                if let name = wildcard.parameter {
                    parameters.set(name, to: slice)
                }
                
                currentNode = wildcard.node
                continue search
            }
            
            if let (catchall, subpaths) = currentCatchall {
                parameters.setCatchall(matched: subpaths)
                return catchall.output
            } else {
                return nil
            }
        }
        
        if let output = currentNode.output {
            return output
        } else if let (catchall, subpaths) = currentCatchall {
            parameters.setCatchall(matched: subpaths)
            return catchall.output
        } else {
            return nil
        }
    }
    
    public var description: String {
        return self.root.description
    }
}

extension YJYRouterNode {
    
    /// 节点结构
    final class Node: CustomStringConvertible {
        
        /// 描述与'*'内容匹配的节点
        final class WildCard {
            private(set) var parameter: String?
            private(set) var explicitlyIncludesAnything = false
            
            let node: Node
            
            private init(node: Node) {
                self.node = node
            }
            
            static func anything(_ node: Node) -> WildCard {
                let wildcard = WildCard(node: node)
                wildcard.explicitlyIncludesAnything = true
                return wildcard
            }
            
            static func parameter(_ node: Node, named name: String) -> WildCard {
                let wildcard = WildCard(node: node)
                wildcard.setParameterName(name)
                return wildcard
            }
            
            func setParameterName(_ name: String) {
                parameter = name
            }
            
            func explicitlyIncludeAnything() {
                explicitlyIncludesAnything = true
            }
        }
        
        /// 所有常量子节点
        var constants: [String: Node]
        
        /// 通配符子节点，可以是命名参数或任何东西
        var wildcard: WildCard?
        
        /// 包含所有路径节点
        var catchall: Node?
        
        ///输出参数
        var output: YJYURLRequestHandler?
        
        ///初始化
        init(output: YJYURLRequestHandler? = nil) {
            self.output = output
            self.constants = [String: Node]()
        }
        
        /// 为提供的路径组件获取子 节点，或构建
        /// 如有必要，在树上添加一个新段。
        func buildOrFetchChild(for component: YJYRouterPathComponent) -> Node {
            
            switch component {
            case .constant(let string):
                let string = string.lowercased()
                if let node = self.constants[string] {
                    return node
                }
                let node = Node()
                self.constants[string] = node
                return node
            case .parameter(let name):
                let node: Node
                if let wildcard = wildcard {
                    if let existingName = wildcard.parameter {
                        precondition(existingName == name, "不可能有两个具有相同前缀但参数名称不用的路由， 冲突字段一个为\(name)另一个为\(existingName)")
                    } else {
                        wildcard.setParameterName(name)
                    }
                    node = wildcard.node
                } else {
                    node = Node()
                    self.wildcard = .parameter(node, named: name)
                }
                return node
            case .anything:
                let node: Node
                if let wildcard = wildcard {
                    wildcard.explicitlyIncludeAnything()
                    node = wildcard.node
                } else {
                    node = Node()
                    self.wildcard = .anything(node)
                }
                return node
            case .catchall:
                let node: Node
                if let fallback = self.catchall {
                    node = fallback
                } else {
                    node = Node()
                    self.catchall = node
                }
                return node
            }
        }
        
        var description: String {
            self.subpathDescriptions.joined(separator: "\n")
        }
        
        var subpathDescriptions: [String] {
            var desc: [String] = []
            for (name, constant) in self.constants {
                desc.append("→ \(name)")
                desc += constant.subpathDescriptions.indented()
            }
            
            if let wildcard = self.wildcard {
                if let name = wildcard.parameter {
                    desc.append("→ :\(name)")
                    desc += wildcard.node.subpathDescriptions.indented()
                }
                
                if wildcard.explicitlyIncludesAnything {
                    desc.append("→ *")
                    desc += wildcard.node.subpathDescriptions.indented()
                }
            }
            
            if let _ = self.catchall {
                desc.append("→ **")
            }
            return desc
        }
    }
}

private extension Array where Element == String {
    func indented() -> [String] {
        return self.map { "  " + $0 }
    }
}
