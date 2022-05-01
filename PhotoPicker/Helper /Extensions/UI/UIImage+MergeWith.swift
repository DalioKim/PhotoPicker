//
//  UIImage+ MergeWith.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/02.
//

import UIKit

extension UIImage {
    func mergeWith(subImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let subWidthSize = self.size.width / 2
        let subHeightSize = self.size.height / 2
        subImage.draw(in: CGRect(x: (self.size.width - subWidthSize) / 2.0, y: (self.size.height - subHeightSize) / 2.0, width: subWidthSize, height: subHeightSize), blendMode: .normal, alpha: 1.0)
        
        if let mergedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return mergedImage
        } else {
            return UIImage()
        }
    }
}

