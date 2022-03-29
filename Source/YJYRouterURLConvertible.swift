//
//  BMRouterURLConvertible.swift
//  BMRouter
//
//  Created by keyon on 2022/3/26.
//

import UIKit

public protocol YJYRouterURLConvertible {
    var yjy_url: URL? { get }
    var yjy_urlString: String { get }
}

extension String: YJYRouterURLConvertible {
  public var yjy_url: URL? {
    if let url = URL(string: self) {
      return url
    }
    var set = CharacterSet()
    set.formUnion(.urlHostAllowed)
    set.formUnion(.urlPathAllowed)
    set.formUnion(.urlQueryAllowed)
    set.formUnion(.urlFragmentAllowed)
    return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
  }

  public var yjy_urlString: String {
    return self
  }
}

extension URL: YJYRouterURLConvertible {
  public var yjy_url: URL? {
    return self
  }

  public var yjy_urlString: String {
    return self.absoluteString
  }
}
