//
//  PhotoAlbumItemCellModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import Foundation

class PhotoAlbumItemCellModel {
    private weak var parentViewModel: DefaultPhotoAlbumViewModel?
    private let model: Photo
    
    init(parentViewModel: DefaultPhotoAlbumViewModel?, model: Photo) {
        self.parentViewModel = parentViewModel
        self.model = model
    }
}

extension PhotoAlbumItemCellModel {
    var asset: PHPhotoManager.asset {
        model.asset
    }
}
