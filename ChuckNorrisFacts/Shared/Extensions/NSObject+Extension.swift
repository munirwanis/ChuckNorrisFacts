//
//  NSObject+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import UIKit

protocol Identifying {}

extension Identifying where Self: NSObject {

    static var identifier: String { return String(describing: self) }

    static var applicationName: String {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Chuck Norris Facts"
    }
}

extension NSObject: Identifying {}
