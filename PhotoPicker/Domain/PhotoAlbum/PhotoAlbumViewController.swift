//
//  PhotoAlbumViewController.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhotoAlbumViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoAlbumItemCell.self, forCellWithReuseIdentifier: PhotoAlbumItemCell.className)
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
        
        setupViews()
        bindCollectionView()
    }

    // MARK: - private
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.cellModelsObs
            .bind(to: collectionView.rx.items) { collectionView, index, cellModel in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumItemCell.className, for: indexPath)
                (cell as? Bindable).map { $0.bind(cellModel) }
                return cell
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - collectionViewLayout.sectionInsets.horizontal
        return PhotoAlbumItemCell.size(width: width)
    }
}
