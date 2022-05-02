//
//  PHPhotoManager.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import UIKit
import RxSwift
import Photos

class PHPhotoManager: PHPhotoLibrary {
    typealias asset = PHAsset
    
    static var assets: PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }
    
    static func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?) -> Observable<(UIImage)> {
        return PHImageManager.default().rx.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil)
    }
    
    static func requestPhoto() -> Observable<PHAuthorizationStatus> {
      Observable<PHAuthorizationStatus>.create { observable in
        PHPhotoLibrary.requestAuthorization {
          observable.onNext($0)
          observable.onCompleted()
        }
        return Disposables.create()
      }
    }
}
