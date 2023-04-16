//
//  SavedRecipesViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 19.03.2023.
//

import UIKit
import SnapKit
import CoreData

class FavoriteRecipesViewController: UIViewController {
        
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            navigationItem.rightBarButtonItem?.isEnabled = !recipes.isEmpty
        }
    }
    
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshRecipes), for: .valueChanged)
        return refreshControl
    }()
        
    private lazy var dialogMessage: UIAlertController = {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Do you want to clear all records?", preferredStyle: .alert)
        let clear = UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.clearFavoriteRecipes()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(clear)
        return dialogMessage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        title = "Favorites"
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(presentDialogMessage))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
        
    }
    
    private func setupData() {
        recipes.removeAll()
        for (key, _) in AppDelegate.userDefaults.dictionaryRepresentation() {
            do {
                var recipe = try AppDelegate.userDefaults.getObject(forKey: key, castTo: Recipe.self)
                recipe.isFavorite = true
                recipes.append(recipe)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func refreshRecipes() {
        setupData()
    }
    
    @objc private func presentDialogMessage() {
        present(dialogMessage, animated: true)
    }
    
    private func clearFavoriteRecipes() {
        AppDelegate.userDefaults.resetDefaults()
        recipes.removeAll()
    }
    
    private func fetchRecipes() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
//        AppDelegate.sharedAppDelegate.persistentContainer.perform {
//            do {
//                let result = try fetchRequest.execute()
//
//                for recipe in result {
//                    let recip = Recipe(id: Int(recipe.recipeId), title: recipe.title!, readyInMinutes: Int(recipe.readyInMinutes), servings: Int(recipe.servings), sourceUrl: recipe.sourceUrl!, image: recipe.image, summary: recipe.summary!, extendedIngredients: recipe.extendedIngredient!.allObjects as! [ExtendedIngredient], instructions: recipe.instructions!)
//                }
//            } catch {
//                print("Unable to Execute Fetch Request, \(error)")
//            }
//        }
    }
    
}

    
extension FavoriteRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let recipe = recipes[indexPath.item]
        
        let detailedViewController = DetailedViewController(recipe: recipe)
        
        navigationController?.pushViewController(detailedViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            AppDelegate.userDefaults.removeObject(forKey: "\(recipes[indexPath.item].id)")
            // remove the item from the data model
            recipes.remove(at: indexPath.row)

            // delete the table view row
            recipes.isEmpty
            ? tableView.reloadData()
            : tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
