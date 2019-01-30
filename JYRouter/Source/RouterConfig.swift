//
//  RouterConfig.swift
//  JYRouter
//
//  Created by 叶金永 on 2019/1/30.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class RouterConfig: NSObject {
	
	public var webViewController:String = ""
	
	internal static let shared:RouterConfig = {
		let config = RouterConfig()
		return config
	}()
}
