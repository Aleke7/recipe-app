    //
    //  DetailedViewController.swift
    //  Recipe App
    //
    //  Created by Almat Begaidarov on 13.03.2023.
    //

import UIKit
import SnapKit
import CoreData

class DetailedViewController: UIViewController {
    
    private var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
        if let urlString = recipe.image {
            imageView.load(urlString: urlString)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.text = recipe.title
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var recipeReadyInMunutesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.imagePlusText(
            amount: "\(recipe.readyInMinutes)",
            image: UIImage(systemName: "clock.fill"),
            for: .minutes
        )
        return label
    }()
    
    private lazy var recipeServingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.imagePlusText(
            amount: "\(recipe.servings)",
            image: UIImage(systemName: "person.3.fill"),
            for: .servings
        )
        return label
    }()
    
    private lazy var recipeSaveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        if recipe.isFavorite {
            button.tintColor = .systemYellow
            button.isSelected = true
        } else {
            button.tintColor = .systemGray
            button.isSelected = false
        }
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        button.addTarget(self, action: #selector(starButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var recipeSummaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.text = recipe.summary.htmlToString
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var recipeIngredientsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.text = ingredientsString
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var recipeInstructionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.text = !recipe.instructions.isEmpty ? recipe.instructions.htmlToString : "❌"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.addSubview(stackView)
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(recipeImageView)
        stackView.addArrangedSubview(recipeTitleLabel)
        stackView.addArrangedSubview(innerStackView)
        stackView.addArrangedSubview(recipeHeaderLabel(header: "Summary"))
        stackView.addArrangedSubview(recipeSummaryLabel)
        stackView.addArrangedSubview(recipeHeaderLabel(header: "Instructions"))
        stackView.addArrangedSubview(recipeInstructionsLabel)
        stackView.addArrangedSubview(recipeHeaderLabel(header: "Ingredients"))
        stackView.addArrangedSubview(recipeIngredientsLabel)
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(recipeReadyInMunutesLabel)
        stackView.addArrangedSubview(recipeSaveButton)
        stackView.addArrangedSubview(recipeServingsLabel)
        return stackView
    }()
    
    private var ingredientsString: String {
        var ingredientsString = ""
        for ingredient in recipe.extendedIngredients {
            let num = ingredient.amount.rationalApproximationOf().0
            let den = ingredient.amount.rationalApproximationOf().1
            if den != 1 {
                ingredientsString += "- \(ingredient.name.capitalizedSentence): \(num)/\(den) \(ingredient.unit)\n"
            } else {
                ingredientsString += "- \(ingredient.name.capitalizedSentence): \(num) \(ingredient.unit)\n"
            }
        }
        return ingredientsString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func recipeHeaderLabel(header: String) -> UILabel {
        let label = UILabel()
        label.text = header
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }
    
    @objc private func presentShareSheet() {
        guard let url = URL(string: recipe.sourceUrl) else {
            return
        }
        
        let shareSheetViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        present(shareSheetViewController, animated: true)
        
    }
    
    @objc private func starButtonClicked() {
        if recipeSaveButton.isSelected {
            recipeSaveButton.tintColor = .systemYellow
            recipeSaveButton.isSelected = false
            do {
                recipe.isFavorite = true
//                try AppDelegate.userDefaults.setObject(object: recipe, forKey: "\(recipe.id)")
                try saveRecipe()
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            recipeSaveButton.tintColor = .systemGray
            recipeSaveButton.isSelected = true
            recipe.isFavorite = false
            AppDelegate.userDefaults.removeObject(forKey: "\(recipe.id)")
        }
    }
    
    private func saveRecipe() throws {
        
        let managedContext = AppDelegate.sharedAppDelegate.persistentContainer.viewContext
        
        let recipeEntity = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: managedContext)!
//        let ingredientEntity = NSEntityDescription.entity(forEntityName: "ExtendedIngredientEntity", in: managedContext)!
        
        let rec = NSManagedObject(entity: recipeEntity, insertInto: managedContext)
//        let ingredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext)
        
        let r = RecipeEntity(context: managedContext)
        r.recipeId = Int16(recipe.id)
        r.title = recipe.title
        r.readyInMinutes = Int16(recipe.readyInMinutes)
        r.servings = Int16(recipe.servings)
        r.image = recipe.image
        r.summary = recipe.summary
        r.sourceUrl = recipe.sourceUrl
        r.instructions = recipe.instructions
        r.isFavorite = recipe.isFavorite
        r.extendedIngredient = NSSet(array: recipe.extendedIngredients)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        title = "Recipe"
        view.addSubview(scrollView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(presentShareSheet))
        
        navigationItem.largeTitleDisplayMode = .never
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
            make.width.equalTo(view.safeAreaInsets)
        }
        
    }
    
}


//            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
//            let recipeEntity = RecipeEntity(context: managedContext)
//            recipeEntity.setValue(recipeId, forKeyPath: #keyPath(RecipeEntity.recipeId))
//            recipeEntity.setValue(recipeTitle, forKey: #keyPath(RecipeEntity.title))
//            recipeEntity.setValue(recipeReadyInMinutes, forKey: #keyPath(RecipeEntity.readyInMinutes))
//            recipeEntity.setValue(recipeServings, forKey: #keyPath(RecipeEntity.servings))
//            recipeEntity.setValue(recipeSourceUrlString, forKey: #keyPath(RecipeEntity.sourceUrl))
//            recipeEntity.setValue(recipeImage, forKey: #keyPath(RecipeEntity.image))
//            recipeEntity.setValue(recipeSummary, forKey: #keyPath(RecipeEntity.summary))
//            recipeEntity.setValue(ingredientsString, forKey: #keyPath(RecipeEntity.extendedIngredients))
//            recipeEntity.setValue(recipeInstructions, forKey: #keyPath(RecipeEntity.instructions))
//            recipeEntity.setValue(recipePricePerServing, forKey: #keyPath(RecipeEntity.pricePerServing))
//            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
