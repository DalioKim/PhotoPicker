//
//  PHPhotoLibrary.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import RxSwift
import Photos

extension PHPhotoLibrary {
  static var authorized: Observable<Bool> {
    
    return Observable.create { observer in
      
      DispatchQueue.main.async {
        switch authorizationStatus() {
        // CASE: 승인 이력 존재
        case .authorized:
          observer.onNext(true) // 더 할 것 없음. 바로 true emit
        // CASE: 승인 이력 없음
        case .notDetermined,
             .restricted,
             .denied,
             .limited:
          observer.onNext(false) // 일단 승인내역 없음을 알림.
          // 다시 권한 요청
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
}
