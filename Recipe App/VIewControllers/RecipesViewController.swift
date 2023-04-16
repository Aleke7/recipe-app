//
//  ViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 08.03.2023.
//

import UIKit
import SnapKit

class RecipesViewController: UIViewController {
        
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshRecipes), for: .valueChanged)
        refreshControl.beginRefreshing()
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        title = "Recipes"
        view.addSubview(tableView)
        
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
        
    }
    
    private func setupData() {
        NetworkClient.shared.getData() { [weak self] in
            guard let self else {
                return
            }
            self.recipes = NetworkClient.shared.recipes.recipes
        }
    }
    
    @objc private func refreshRecipes() {
        setupData()
    }

}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else {
            fatalError("The TableView could not dequeue RecipeCell")
        }
        
        let recipe = recipes[indexPath.item]
        
        cell.configure(
            urlString: recipe.image,
            title: recipe.title,
            readyInMinutes: recipe.readyInMinutes,
            servings: recipe.servings
        )
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var recipe = recipes[indexPath.item]
        
        do {
            recipe = try AppDelegate.userDefaults.getObject(forKey: "\(recipe.id)", castTo: Recipe.self)
            recipe.isFavorite = true
        } catch {
            print(error.localizedDescription)
        }
        
        let detailedViewController = DetailedViewController(recipe: recipe)
        
        navigationController?.pushViewController(detailedViewController, animated: true)
        
    }
    
}
            
