//
//  BViewController.swift
//  JYRouter
//
//  Created by Keyon on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class BViewController: UIViewController,Routable {

	static func initWithParams(params: Parameter?) -> UIViewController {
		if let params = params {
			debugPrint(params)
		}
		return YJYTools.storyBoradVC(storyBoardName: "Main", identifier: "BViewController")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
}
