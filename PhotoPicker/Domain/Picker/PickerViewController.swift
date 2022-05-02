//
//  PickerViewController.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/04/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PickerViewController: UIViewController {
    
    // MARK: - private
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 40
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().multipliedBy(0.7)
        }
        collectionView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(10)
        }
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PickerItemCell.self, forCellWithReuseIdentifier: PickerItemCell.className)
        return collectionView
    }()
    
    private let saveImageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "사진 저장하기", style: .plain, target: self, action: nil)
        return button
    }()
    
    private var viewModel: DefaultPickerViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: DefaultPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        bindImage()
        bindSaveButton()
        bindCollectionView()
        bindMergedImage()
    }
    
    private func bindImage() {
        let targetSize = CGSize(width: view.bounds.width, height: 200)
        imageView.setImage(viewModel.asset, targetSize: targetSize)
    }
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.cellModelsObs
            .bind(to: collectionView.rx.items) { collectionView, index, cellModel in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickerItemCell.className, for: indexPath)
                (cell as? Bindable).map { $0.bind(cellModel) }
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PickerItemCellModel.self)
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                let targetSize = CGSize(width: self.imageView.bounds.width / 2, height: self.imageView.bounds.height / 2)
                self.showAlert(title: "해상도를 선택해주세요")
                    .subscribe(onNext: { [weak self] grade in
                        guard let self = self else { return }
                        self.viewModel.didSelectItem(image, targetSize: targetSize, grade: grade)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMergedImage() {
        viewModel.mergedImageObs
            .subscribe(onNext: { [weak self] in
                self?.imageView.image = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSaveButton() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .subscribe(onNext: { [weak self] _ in
                self?.navigationItem.rightBarButtonItem = self?.saveImageButton
            })
            .disposed(by: disposeBag)
        
        saveImageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.saveMergedImage()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height - collectionViewLayout.sectionInsets.vertical
        return PickerItemCell.size(height: height)
    }
}
