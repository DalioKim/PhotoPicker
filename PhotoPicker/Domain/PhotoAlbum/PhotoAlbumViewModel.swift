//
//  PhotoAlbumViewModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import RxSwift
import RxRelay
import Photos
import UIKit


protocol PhotoAlbumViewModelInput {
    func didSelectItem(_ model: PhotoAlbumItemCellModel)
}

protocol PhotoAlbumViewModelOutput {
    associatedtype ViewAction
    var cellModels: [PhotoAlbumItemCellModel] { get }
    var cellModelsObs: Observable<[PhotoAlbumItemCellModel]> { get }
    var viewActionObs: Observable<ViewAction> { get }
}

protocol PhotoAlbumViewModel: PhotoAlbumViewModelInput, PhotoAlbumViewModelOutput {}

final class DefaultPhotoAlbumViewModel: PhotoAlbumViewModel {
    typealias ViewAction = DefaultMovieListViewAction
    
    enum DefaultMovieListViewAction {
        case popViewController
        case showPickerView
    }
    
    // MARK: - Relay & Observer
    
    private let disposeBag = DisposeBag()
    
    private let cellModelsRelay = BehaviorRelay<[PhotoAlbumItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>()
    
    var cellModelsObs: Observable<[PhotoAlbumItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var cellModels: [PhotoAlbumItemCellModel] {
        cellModelsRelay.value ?? []
    }
    
    var viewActionObs: Observable<ViewAction> {
        viewActionRelay.asObservable()
    }
    
    // MARK: - Init
    
    init() {
        fetch()
    }
    
    private func fetch() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                var list = [PhotoAlbumItemCellModel]()
                assets.enumerateObjects { asset, _, _ in
                    list.append(PhotoAlbumItemCellModel(parentViewModel: self, model: Photo(asset: asset)))
                }
                self?.cellModelsRelay.accept(list)
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultPhotoAlbumViewModel {
    func didSelectItem(_ model: PhotoAlbumItemCellModel) {
        viewActionRelay.accept(ViewAction.showPickerView)
    }
}
