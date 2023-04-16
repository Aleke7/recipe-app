//
//  SettingsViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 19.03.2023.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        view.addSubview(tableView)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
        
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell else {
            fatalError("The TableView could not dequeue RecipeCell")
        }
        
        return cell
    }


}
