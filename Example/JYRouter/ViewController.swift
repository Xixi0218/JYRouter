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
		var params = YJYParameter()
		params["title"] = "Keyon"
		params["userId"] = "123"
		YJYRouter.routeTo("BViewController?name=Mike", params: params)
	}
	
	@IBAction func clickTwo(_ sender: Any) {
		var params = YJYParameter()
		params["title"] = "Keyon"
		params["userId"] = "123"
		YJYRouter.routeTo("BViewController", params: params)
	}
}

