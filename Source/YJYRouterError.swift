//
//  YJYRouterError.swift
//  YJYRouter
//
//  Created by keyon on 2022/3/17.
//

import UIKit

/// 通用错误体
public enum YJYRouterError: Error {
    case notResigter
    case requestError
    case redirect(url: String, action: YJYRouterAction, isExcuteMiddleWares: Bool)
    case redirectObject(object: Any)
}

public enum YJYRouterAction {
    case none
    case present
    case push
}
