//
//  PhotoAlbumViewModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/29.
//

import RxSwift
import RxRelay
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
    typealias ViewAction = DefaultPhotoAlbumViewAction
    
    enum DefaultPhotoAlbumViewAction {
        case popViewController
        case showPickerView(model: PhotoAlbumItemCellModel)
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
        bindFetch()
    }
    
    private func bindFetch() {
        PHPhotoManager.authorized
            .subscribe(onNext: { [weak self] _ in
                var list = [PhotoAlbumItemCellModel]()
                PHPhotoManager.assets.enumerateObjects { asset, _, _ in
                    list.append(PhotoAlbumItemCellModel(parentViewModel: self, model: Photo(asset: asset)))
                }
                self?.cellModelsRelay.accept(list)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - INPUT. View event methods

extension DefaultPhotoAlbumViewModel {
    func didSelectItem(_ model: PhotoAlbumItemCellModel) {
        viewActionRelay.accept(ViewAction.showPickerView(model: model))
    }
}
