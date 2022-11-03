//
//  YJYCompatible.swift
//  JYRouter
//
//  Created by keyon on 2022/11/3.
//  Copyright © 2022 Keyon. All rights reserved.
//

import Foundation

public struct YJYReactive<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol YJYCompatible {
    /// Extended type
    associatedtype ReactiveBase

    /// Reactive extensions.
    static var yjy: YJYReactive<ReactiveBase>.Type { get set }

    /// Reactive extensions.
    var yjy: YJYReactive<ReactiveBase> { get set }
}

extension YJYCompatible {
    /// Reactive extensions.
    public static var yjy: YJYReactive<Self>.Type {
        get { YJYReactive<Self>.self }
        // this enables using Reactive to "mutate" base type
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    /// Reactive extensions.
    public var yjy: YJYReactive<Self> {
        get { YJYReactive(self) }
        // this enables using Reactive to "mutate" base object
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}
