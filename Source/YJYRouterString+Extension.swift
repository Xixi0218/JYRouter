//
//  YJYRouterString+Extension.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/17.
//

import Foundation

extension URL {
    
    /// 除参数以外的路径
    public var yjy_fullRoute: String {
        var resultScheme = ""
        if let scheme = scheme {
            resultScheme = "\(scheme)://"
        }
        return resultScheme + (host ?? "") + path
    }
    
    /// 包含host和scheme的path字符串
    public var yjy_path: String {
        var resultScheme = ""
        if let scheme = scheme {
            resultScheme = "\(scheme)/"
        }
        return resultScheme + (host ?? "") + path
    }
    
    /// 分割包含host的path字符串
    public var yjy_paths: [String] {
        return yjy_path.split(separator: "/").map{ String.init($0) }
    }
    
    /// 分割包含host的path字符串生成对应PathComponent
    public var yjy_pathComponents: [YJYRouterPathComponent] {
        return yjy_path.split(separator: "/").map { .init(stringLiteral: .init($0)) }
    }
    
    /// 获取url的参数
    public var yjy_queryParameters: [String: String] {
        var parameters = [String: String]()
        guard let urlComponents = NSURLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = urlComponents.queryItems else {
            return parameters
        }
        queryItems.forEach({ (item) in
            parameters[item.name] = item.value
        })
        return parameters
    }
    
}

extension Dictionary {
    public func getString(forKey key: Key, defaultValue def: String = "") -> String {
        if let str = self[key] as? String {
            return str
        }
        return def
    }
    
    public func getFloat(forKey key: Key, defaultValue def: Float = 0.0) -> Float {
        if let num = self[key] as? Float {
            return num
        } else if let str = self[key] as? String {
            if let val = Float(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Float(truncating: num)
        }
        return def
    }
    
    public func getDouble(forKey key: Key, defaultValue def: Double = 0.0) -> Double {
        if let num = self[key] as? Double {
            return num
        } else if let str = self[key] as? String {
            if let val = Double(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Double(truncating: num)
        }
        return def
    }
    
    public func getInt(forKey key: Key, defaultValue def: Int = 0) -> Int {
        if let num = self[key] as? Int {
            return num
        } else if let str = self[key] as? String {
            if let val = Int(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Int(truncating: num)
        }
        return def
    }
    
    public func getBool(forKey key: Key, defaultValue def: Bool = false) -> Bool {
        if let val = self[key] as? Bool {
            return val
        } else if let num = self[key] as? NSNumber {
            if num == 0 {
                return false
            } else if num == 1 {
                return true
            }
        } else if let str = self[key] as? String {
            if str.lowercased() == "true" || str.lowercased() == "yes" {
                return true
            } else if str.lowercased() == "false" || str.lowercased() == "no" {
                return false
            }
        }
        return def
    }
}
