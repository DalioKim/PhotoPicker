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
        bindCollectionView()
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
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - collectionViewLayout.sectionInsets.horizontal
        let height = collectionView.frame.size.height - collectionViewLayout.sectionInsets.vertical
        print("width \(width) height \(height)")
        return PickerItemCell.size(height: height)
    }
}
