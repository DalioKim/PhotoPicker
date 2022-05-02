//
//  PickerViewModel.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import RxSwift
import RxRelay

protocol PickerViewModelInput {
    func didSelectItem(_ model: PickerItemCellModel, targetSize: CGSize, grade: CGFloat)
    func saveMergedImage()
}

protocol PickerViewModelOutput {
    associatedtype ViewAction
    var cellModelsObs: Observable<[PickerItemCellModel]> { get }
    var mergedImageObs: Observable<UIImage> { get }
    var viewActionObs: Observable<ViewAction> { get }
}

protocol PickerViewModel: PickerViewModelInput, PickerViewModelOutput {}

final class DefaultPickerViewModel: PickerViewModel {
    typealias ViewAction = DefaultPickerViewAction
    
    enum DefaultPickerViewAction {
        case showPhotoAlbumView
    }
    
    private let model: PhotoAlbumItemCellModel
    
    private let cellModelsRelay = BehaviorRelay<[PickerItemCellModel]?>(value: nil)
    private let mergedImageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let saveMergedImageRelay = PublishRelay<UIImage?>()
    private let viewActionRelay = PublishRelay<ViewAction>()
    
    private let disposeBag = DisposeBag()
    
    var cellModelsObs: Observable<[PickerItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var mergedImageObs: Observable<UIImage> {
        mergedImageRelay.map { $0 ?? UIImage() }
    }
    
    var viewActionObs: Observable<ViewAction> {
        viewActionRelay.asObservable()
    }
    
    // MARK: - Init
    
    init(model: PhotoAlbumItemCellModel) {
        self.model = model
        bind()
        bindSaveImage()
    }
    
    private func bind() {
        cellModelsRelay.accept(UIImage.Asset.allCases.map { PickerItemCellModel(parentViewModel: self, image: $0.image) })
    }
    
    private func bindSaveImage() {
        saveMergedImageRelay
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                guard let image = image else { return }
                PHPhotoManager.saveImage(image)
                    .subscribe(onNext: { [weak self] image in
                        self?.viewActionRelay.accept(ViewAction.showPhotoAlbumView)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension DefaultPickerViewModel {
    var asset: PHPhotoManager.asset {
        model.asset
    }
}

// MARK: - INPUT. View event methods

extension DefaultPickerViewModel {
    func didSelectItem(_ model: PickerItemCellModel, targetSize: CGSize, grade: CGFloat) {
        PHPhotoManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil)
            .subscribe(onNext: { [weak self] in
                self?.mergedImageRelay.accept($0.mergeWith(subImage: model.image, grade: grade))
            })
            .disposed(by: disposeBag)
    }
    
    func saveMergedImage() {
        saveMergedImageRelay.accept(mergedImageRelay.value)
    }
}
