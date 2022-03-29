//
//  YJYLoginMiddleWare.swift
//  JYRouter
//
//  Created by keyon on 2022/3/29.
//  Copyright © 2022 Keyon. All rights reserved.
//

import UIKit

class YJYLoginMiddleWare: YJYRouterMiddleWare {
    
    private var isLogin = true
    
    func willRoute(_ url: String) throws {
        guard isLogin else {
            if url != YJYRouterMenu.login {
                YJYRouter.default.present(YJYRouterMenu.login)
            }
            throw YJYRouterError.pathError
        }
    }
}
