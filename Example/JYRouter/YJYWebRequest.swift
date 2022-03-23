//
//  YJYWebRequest.swift
//  JYRouter
//
//  Created by keyon on 2022/3/23.
//  Copyright © 2022 Keyon. All rights reserved.
//

import UIKit

struct YJYWebRequest: YJYRouterReuqest {
    public typealias Response = UIViewController
    
    /// 请求体对应的url
    public static var url: String { "yjy://webView" }
    
    /// 根据url和url的参数生成对应请求体
    public static func decode(from url: URL, urlParameters: YJYRouterParameters, queryParams: [String: Any], context: Any?) -> Self {
        let title = (queryParams["title"] as? String) ?? ""
        let url = (queryParams["url"] as? String) ?? ""
        return self.init(navTitle: title, urlStr: url)
    }
    
    let navTitle:String
    let urlStr:String
}
