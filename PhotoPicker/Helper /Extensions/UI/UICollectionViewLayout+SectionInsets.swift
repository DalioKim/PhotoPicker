//
//  UICollectionViewLayout+SectionInsets.swift
//  PhotoPicker
//
//  Created by κΉλν on 2022/04/30.
//

import UIKit

extension UICollectionViewLayout {
   var sectionInsets: UIEdgeInsets {
     (self as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
  }
}
