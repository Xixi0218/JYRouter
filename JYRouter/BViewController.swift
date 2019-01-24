//
//  BViewController.swift
//  JYRouter
//
//  Created by 叶金永 on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit

class BViewController: UIViewController,Routable {

	static func initWithParams(params: Parameter?) -> UIViewController {
		debugPrint(params)
		return Constants.storyBoradVC(storyBoardName: "Main", identifier: "BViewController")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
}
