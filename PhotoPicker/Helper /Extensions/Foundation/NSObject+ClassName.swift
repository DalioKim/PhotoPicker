//
//  NSObject+ClassName.swift
//  PhotoPicker
//
//  Created by κΉλν on 2022/04/30.
//

import Foundation

@objc
extension NSObject {
    class var className: String {
        String(describing: self)
    }
}
