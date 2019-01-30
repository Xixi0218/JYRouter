//
//  String+Sub.swift
//  JYRouter
//
//  Created by Keyon on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import Foundation

extension String {
	
	/// 从String中截取出参数
	var yjy_urlParameters: [String: Any]? {
		// 截取是否有参数
		guard let urlComponents = NSURLComponents(string: self), let queryItems = urlComponents.queryItems else {
			return nil
		}
		// 参数字典
		var parameters = [String: Any]()
		// 遍历参数
		queryItems.forEach({ (item) in
			// 判断参数是否是数组
			if let existValue = parameters[item.name], let value = item.value {
				// 已存在的值，生成数组
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

