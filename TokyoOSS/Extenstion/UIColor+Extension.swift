//
//  UIColor+Extension.swift
//  TokyoOSS
//
//  Created by ミズキ on 2021/11/28.
//65, 201, 180

import Foundation
import UIKit
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
let appColor:UIColor = .rgb(red: 65, green: 201, blue: 180)
