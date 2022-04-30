//
//  PhotoAlbumViewController.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import RxSwift
import UIKit

class PhotoAlbumViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
        
    private var viewModel: DefaultPhotoAlbumViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Init
    
    init(viewModel: DefaultPhotoAlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - private
    
    private func bindCollectionView() {
        viewModel.cellModelsObs
    }
}



