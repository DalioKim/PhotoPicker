//
//  PickerItemCellModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/01.
//

import Foundation
import UIKit

class PickerItemCellModel {
    private weak var parentViewModel: DefaultPickerViewModel?
    let image: UIImage
    
    init(parentViewModel: DefaultPickerViewModel?, image: UIImage) {
        self.parentViewModel = parentViewModel
        self.image = image
    }
}

