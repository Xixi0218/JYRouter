//
//  Constants.swift
//  JYRouter
//
//  Created by Keyon on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class YJYTools: NSObject {
	
	///获取当前页面
	public class func currentTopViewController() -> UIViewController? {
		if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
			return currentTopViewController(rootViewController: rootViewController)
		} else {
			return nil
		}
	}
	
	public class func currentTopViewController(rootViewController: UIViewController) -> UIViewController {
		if (rootViewController.isKind(of: UITabBarController.self)) {
			let tabBarController = rootViewController as! UITabBarController
			return currentTopViewController(rootViewController: tabBarController.selectedViewController!)
		}
		if (rootViewController.isKind(of: UINavigationController.self)) {
			let navigationController = rootViewController as! UINavigationController
			return currentTopViewController(rootViewController: navigationController.visibleViewController!)
		}
		if ((rootViewController.presentedViewController) != nil) {
			return currentTopViewController(rootViewController: rootViewController.presentedViewController!)
		}
		return rootViewController
	}
	
	public class func storyBoradVC(storyBoardName: String, identifier: String) -> UIViewController {
		let story = UIStoryboard(name: storyBoardName, bundle: nil)
		return story.instantiateViewController(withIdentifier: identifier)
	}
	
}
