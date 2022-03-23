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
        YJYRouter.default.open(request: YJYBRequest())
	}
	
	@IBAction func clickTwo(_ sender: Any) {
        let baidu = "https://www.baidu.com"
        let newUrl = "yjy://webView?url=\(baidu)&title=测试".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: newUrl) {
            YJYRouter.default.open(url: url)
        }
        
	}
}

