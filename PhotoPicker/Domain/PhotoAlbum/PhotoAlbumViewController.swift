//
//  PhotoAlbumViewController.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import Foundation
import RxSwift
import Photos

class PhotoAlbumViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhtoAlbum()
    }

    private func getPhtoAlbum() {
        PHPhotoLibrary.authorized
          .skipWhile { !$0 } // true 값 나올 때까지 skip
          .take(1) // 처음 true값 받고 나면 종료
          .subscribe(
            onNext: { [weak self] _ in
              guard let self = self else { return }
            })
    }
}



