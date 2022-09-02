//
//  YJYLoginMiddleWare.swift
//  JYRouter
//
//  Created by keyon on 2022/3/29.
//  Copyright © 2022 Keyon. All rights reserved.
//

import UIKit

class YJYLoginMiddleWare: YJYRouterMiddleWare {
    
    private var isLogin = false
    
    func willRoute(_ url: String) throws {
        guard isLogin else {
            throw YJYRouterError.redirect(url: YJYRouterMenu.market, action: .present, isExcuteMiddleWares: false)
        }
    }
}
