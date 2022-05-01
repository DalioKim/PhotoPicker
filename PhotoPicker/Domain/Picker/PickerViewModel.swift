//
//  PickerViewModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import RxSwift
import RxRelay
import UIKit
import Photos

protocol PickerViewModelInput {
    func didSelectItem(_ model: PhotoAlbumItemCellModel)
}

protocol PickerViewModelOutput {
    associatedtype ViewAction
    var cellModelsObs: Observable<[PickerItemCellModel]> { get }
}

protocol PickerViewModel: PickerViewModelInput, PickerViewModelOutput {}

final class DefaultPickerViewModel: PickerViewModel {
    typealias ViewAction = DefaultPickerViewAction
    
    enum DefaultPickerViewAction {
        case popViewController
        case showPickerView
    }
    
    private let model: PhotoAlbumItemCellModel
    private let cellModelsRelay = BehaviorRelay<[PickerItemCellModel]?>(value: nil)
    
    var cellModelsObs: Observable<[PickerItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    // MARK: - Init
    
    init(model: PhotoAlbumItemCellModel) {
        self.model = model
        bind()
    }
    
    private func bind() {
        cellModelsRelay.accept(UIImage.Asset.allCases.map { PickerItemCellModel(parentViewModel: self, image: $0.image) })
    }
}

extension DefaultPickerViewModel {
    var asset: PHAsset {
        model.asset
    }
}

// MARK: - INPUT. View event methods

extension DefaultPickerViewModel {
    func didSelectItem(_ model: PhotoAlbumItemCellModel) {
    }
}
