//
//  SwitchCell.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 24.03.2023.
//

import UIKit
import SnapKit

class SwitchCell: UITableViewCell {

    static let identifier = "SwitchCell"
    
    private lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.text = "Dark mode"
        return label
    }()
    
    private lazy var cellSwitch: UISwitch = {
        let sw = UISwitch()
        sw.setOn(true, animated: true)
        sw.setOnValueChangedListener {
            self.window?.overrideUserInterfaceStyle = sw.isOn ? .dark : .light
        }
        return sw
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        cellSwitch.isOn = self.traitCollection.userInterfaceStyle == .dark
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        cellSwitch.isOn = self.traitCollection.userInterfaceStyle == .dark
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(cellTitleLabel)
        stackView.addArrangedSubview(cellSwitch)
        
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

    }
    
}
