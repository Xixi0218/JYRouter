//
//  Router.swift
//  Router
//
//  Created by Keyon on 2019/1/7.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

public typealias  Parameter = [String: Any]

public protocol Routable {
	/**
	类的初始化方法 - params 传参字典
	*/
	static func initWithParams(params: Parameter?) -> UIViewController
}


open class Router {
	
	open class func openTel(_ phone:String) {
		if let url = URL(string: "tel://\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
		}
	}
	
	//获取类名
	private class func swiftClassFromString(className: String) -> AnyClass? {
		// get the project name
		if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
			// YourProject.className
			let classStringName = appName + "." + className
			return NSClassFromString(classStringName)
		}
		return nil;
	}
	
	///网络配置的路由
	open class func routeTo(_ path:String, params:Parameter?, present: Bool = false , animated: Bool = true, hidesBottomBarWhenPushed: Bool = true) {
		if let start = path.range(of: "?") {
			let className = String(path[..<start.lowerBound])
			var customParams = Parameter()
			if let params = params {
				customParams.merge(params) { (param, _) -> Any in
					param
				}
			}
			if let pathParams = path.yjy_urlParameters {
				customParams.merge(pathParams) { (param, _) -> Any in
					param
				}
			}
			self.jumpTo(className, params: customParams, present: present, animated: animated, hidesBottomBarWhenPushed: hidesBottomBarWhenPushed)
		} else {
			self.jumpTo(path, params: params, present: present, animated: animated, hidesBottomBarWhenPushed: hidesBottomBarWhenPushed)
		}
	}
	
	///路由处理
	private class func jumpTo(_ className:String, params:Parameter?, present: Bool = false, animated: Bool = true, hidesBottomBarWhenPushed: Bool = true) {
		if let classPath = self.swiftClassFromString(className: className) {
			if let cls = classPath as? Routable.Type {
				let vc = cls.initWithParams(params: params)
				vc.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
				let topViewController = YJYTools.currentTopViewController()
				if topViewController?.navigationController != nil && !present {
					topViewController?.navigationController?.pushViewController(vc, animated: animated)
				} else {
					topViewController?.present(vc, animated: animated , completion: nil)
					
				}
			} else {
				assert(false, "此类型没有遵守Routable协议")
			}
		} else {
			assert(false, "此类型名不存在")
		}
	}
}


