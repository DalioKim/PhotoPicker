//
//  PhotoAlbumItemCell.swift
//  PhotoPicker
//
//  Created by κΉλν on 2022/04/30.
//

import UIKit
import SnapKit

class PhotoAlbumItemCell: UICollectionViewCell {
    
    // MARK: - nested type
    
    enum Size {
        static let horizontalPadding: CGFloat = 5
        static let verticalPadding: CGFloat = 5
        static let spacing: CGFloat = 5
    }
    
    // MARK: - private
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        stackView.alignment = .center
        
        return stackView
    }()
    
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
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
        }
    }
}

extension PhotoAlbumItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? PhotoAlbumItemCellModel else { return }
        let targetSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        imageView.setImage(model.asset, targetSize: targetSize)
    }
}

extension PhotoAlbumItemCell {
    static func size(width: CGFloat) -> CGSize {
        let cellWidth = (width / 3) - (Size.horizontalPadding * 2)
        let cellWidthheight = (width / 3) - (Size.verticalPadding * 2)
        return CGSize(width: cellWidth, height: cellWidthheight)
    }
}
