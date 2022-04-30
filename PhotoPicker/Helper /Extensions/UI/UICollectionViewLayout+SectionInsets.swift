//
//  UICollectionViewLayout+SectionInsets.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import UIKit

extension UICollectionViewLayout {
   var sectionInsets: UIEdgeInsets {
     (self as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
  }
}
