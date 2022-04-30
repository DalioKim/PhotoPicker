//
//  UIEdgeInsets.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat {
        left + right
    }
    var vertical: CGFloat {
        top + bottom
    }
}
