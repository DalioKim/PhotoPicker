//
//  PickerItemCell.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/01.
//

import UIKit
import SnapKit

class PickerItemCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupViews() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
    }
}

extension PickerItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? PickerItemCellModel else { return }
        imageView.image = model.image
    }
}

extension PickerItemCell {
    static func size(height: CGFloat) -> CGSize {
        return CGSize(width: height - 30, height: height - 30)
    }
}
