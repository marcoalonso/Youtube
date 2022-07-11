//
//  UIColor+Extension.swift
//  Youtube
//
//  Created by marco rodriguez on 11/07/22.
//
import Foundation
import UIKit

extension UIColor{
    @nonobjc class var backgroundColor: UIColor {
        return UIColor(named: "backgroundColor")!
    }
    
    @nonobjc class var grayColor: UIColor {
        return UIColor(named: "grayColor")!
    }
    
    @nonobjc class var whiteColor: UIColor {
        return UIColor(named: "whiteColor")!
    }
}
