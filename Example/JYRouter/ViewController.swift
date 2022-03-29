//
//  ViewController.swift
//  JYRouter
//
//  Created by Keyon on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func clickOne(_ sender: Any) {
        YJYRouter.default.push(YJYRouterMenu.market)
	}
	
	@IBAction func clickTwo(_ sender: Any) {
        YJYRouter.default.push(YJYRouterMenu.detail, params: ["url": "https://www.baidu.com", "title": "测试"])
	}
}

