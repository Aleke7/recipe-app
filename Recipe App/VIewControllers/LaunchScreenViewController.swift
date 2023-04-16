//
//  LaunchScreenViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 05.04.2023.
//

import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            label.text = appName
        }
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}
