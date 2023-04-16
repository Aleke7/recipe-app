//
//  ViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 08.03.2023.
//

import UIKit

class RecipesViewController: UIViewController {
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupData()
    }
    
    
    private func setupUI() {
        
        refreshControl.addTarget(self, action: #selector(refreshRecipes), for: .valueChanged)
        
        tableView.backgroundColor = .systemBackground
        title = "Recipes"
        
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func setupData() {
        NetworkClient.shared.getData() { [weak self] in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                self.recipes = NetworkClient.shared.recipes.recipes
            }
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
            url: recipe.image,
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
            recipe = try userDefaults.getObject(forKey: "\(recipe.id)", castTo: Recipe.self)
            recipe.isFavorite = true
        } catch {
            print(error.localizedDescription)
        }
        
        let detailedViewController = DetailedViewController(recipe: recipe)
        
        navigationController?.pushViewController(detailedViewController, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//            if editingStyle == .delete {
//
//                // remove the item from the data model
//                recipes.remove(at: indexPath.row)
//
//                // delete the table view row
//                tableView.deleteRows(at: [indexPath], with: .fade)
//
//            }
//        }
    
}
            
