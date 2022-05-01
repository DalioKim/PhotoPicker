//
//  UIImage+Asset.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/01.
//

import UIKit

extension UIImage {
    enum Asset: String, CaseIterable {
        case one = "001"
        case two = "002"
        case three = "003"
        case four = "004"
        case five = "005"
        case six = "006"
        case seven = "007"
        case eight = "008"
        case nine = "009"
        case ten = "010"
        case eleven = "011"
        case twelve = "012"
        case thirteen = "013"
        case fourteen = "014"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
