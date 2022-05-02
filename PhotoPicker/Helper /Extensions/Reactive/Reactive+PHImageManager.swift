//
//  Reactive+PHImageManager.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/02.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

extension Reactive where Base: PHImageManager {
    public func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?) -> Observable<(UIImage)> {
        
        return Observable.create({ [weak manager = self.base] (observer) -> Disposable in
            guard let manager = manager else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let requestID = manager
                .requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { image, _ in
                    if let image = image {
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                })
            return Disposables.create {
                manager.cancelImageRequest(requestID)
            }
        })
    }
}
