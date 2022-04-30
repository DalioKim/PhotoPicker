//
//  UIImageView+PHPhotoLibrary.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import Photos
import UIKit

extension UIImageView {
    func setImage(_ asset: PHAsset, targetSize: CGSize, errorImage: UIImage? = nil) {
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { [weak self] image, _ in
            self?.image = image
        }
    }
}
