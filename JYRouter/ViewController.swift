//
//  ViewController.swift
//  JYRouter
//
//  Created by 叶金永 on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func clickOne(_ sender: Any) {
		var params = Parameter()
		params["title"] = "Keyon"
		params["userId"] = "123"
//		Router.routeTo("BViewController", params: params)
		Router.routeTo("BViewController?title=Keyon&userId=123", params: params)
	}
	
	@IBAction func clickTwo(_ sender: Any) {
		var params = Parameter()
		params["title"] = "Keyon"
		Router.routeTo("http://www.baidu.com", params: params)
	}
}

