//
//  Router.swift
//  Router
//
//  Created by 叶金永 on 2019/1/7.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit
//可自行配置webViewController控制器 最好在AppDelegate启动时候调用
public var WebViewControllerName = "WebViewController"

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
	
	class func swiftClassFromString(className: String) -> AnyClass? {
		// get the project name
		if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
			// YourProject.className
			let classStringName = appName + "." + className
			return NSClassFromString(classStringName)
		}
		return nil;
	}
	
	///网络配置的路由
	class func routeTo(_ path:String, params:Parameter?, present: Bool = false , animated: Bool = true) {
		//处理网页
		if path.contains("http") {
			var customParams = Parameter()
			customParams["url"] = path
			if let params = params {
				customParams.merge(params) { (param, _) -> Any in
					param
				}
			}
			self.jumpTo(WebViewControllerName, params: customParams)
			return
		}
		
		if let start = path.range(of: "?") {
			let className = String(path[..<start.lowerBound])
			var parameters:Parameter?
			if let params = params {
				parameters = params
			} else {
				parameters = path.urlParameters
			}
			self.jumpTo(className, params: parameters)
		} else {
			self.jumpTo(path, params: params)
		}
	}
	
	///路由处理
	private class func jumpTo(_ className:String, params:Parameter?, present: Bool = false , animated: Bool = true , hidesBottomBarWhenPushed: Bool = true) {
		if let classPath = self.swiftClassFromString(className: className) {
			if let cls = classPath as? Routable.Type {
				let vc = cls.initWithParams(params: params)
				vc.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
				let topViewController = Constants.currentTopViewController()
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


