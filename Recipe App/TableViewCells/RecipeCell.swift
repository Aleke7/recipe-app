//
//  RecipeCell.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 09.03.2023.
//

import UIKit
import SnapKit

class RecipeCell: UITableViewCell {

    static let identifier = "RecipeCell"
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cellReadyInMunutesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private lazy var cellServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(cellImageView)
        stackView.addArrangedSubview(cellTitleLabel)
        
        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        
        innerStackView.addArrangedSubview(cellReadyInMunutesLabel)
        innerStackView.addArrangedSubview(cellServingsLabel)
        innerStackView.spacing = 8
        
        stackView.addArrangedSubview(innerStackView)
        
        contentView.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        
        cellImageView.layer.cornerRadius = 5
        cellImageView.clipsToBounds = true
        cellImageView.layer.borderWidth = 1
        cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        
    }
    
    func configure(
        urlString: String?,
        title: String,
        readyInMinutes: Int,
        servings: Int
    ) {
        if let urlString = urlString {
            cellImageView.load(urlString: urlString)
        }
        cellTitleLabel.text = title
        cellReadyInMunutesLabel.imagePlusText(amount: "\(readyInMinutes)", image: UIImage(systemName: "clock.fill"), for: .minutes)
        cellServingsLabel.imagePlusText(amount: "\(servings)", image: UIImage(systemName: "person.3.fill"), for: .servings)
    }
    
}
