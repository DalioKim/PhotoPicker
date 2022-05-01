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
    static var authorized: Observable<Bool> {
        
        return Observable.create { observer in
            DispatchQueue.main.async {
                switch authorizationStatus() {
                case .authorized:
                    observer.onNext(true)
                case .notDetermined,
                        .restricted,
                        .denied,
                        .limited:
                    observer.onNext(false)
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                @unknown default:
                #warning("Deal with unkown case")
                }
            }
            return Disposables.create()
        }
    }
    
    static var assets: PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }
    
    static func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?) -> Observable<(UIImage)> {
        return PHImageManager.default().rx.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil)
    }
}
