//
//  NSObject+ClassName.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import Foundation

@objc
extension NSObject {
    class var className: String {
        String(describing: self)
    }
}
