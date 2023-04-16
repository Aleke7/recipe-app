//
//  DetailedViewController.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 13.03.2023.
//

import UIKit

class DetailedViewController: UIViewController {
    private var ingredients: [extendedIngredient] = []
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipeReadyInMunutesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var recipeServingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var recipeSummaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipeIngredientsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.text = ingredientsString
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipeInstructionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private var ingredientsString: String {
        var ingredientsString = ""
        for ingredient in ingredients {
            ingredientsString += "\(ingredient.name!.capitalizedSentence): \(ingredient.amount!) \(ingredient.unit!)\n"
        }
        return ingredientsString
    }
    
    private var sourceUrlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func configure(
        ingredients: [extendedIngredient],
        title: String, summary: String,
        sourceUrl: String,
        instructions: String
    ) {
        self.ingredients = ingredients
        recipeTitleLabel.text = title
        recipeSummaryLabel.text = summary
        self.sourceUrlString = sourceUrl
        recipeInstructionsLabel.text = instructions
    }
    
    func configureImageView(with urlString: String) {
        self.recipeImageView.load(urlString: urlString)
    }
    
    func configureLabels(amount: Int, for additional: Additional) {
        switch additional {
        case .minutes:
            recipeReadyInMunutesLabel.addDataToLabel(
                amount: amount,
                image: UIImage(systemName: "clock.fill"),
                for: .minutes
            )
        case .servings:
            recipeServingsLabel.addDataToLabel(
                amount: amount,
                image: UIImage(systemName: "person.3.fill"),
                for: .servings
            )
        }
    }
    
    @objc private func presentShareSheet() {
        guard let url = URL(string: sourceUrlString), let image = recipeImageView.image else {
            return
        }
        
        let shareSheetViewController = UIActivityViewController(
            activityItems: [image as AnyObject, url as AnyObject],
            applicationActivities: nil
        )
        
        present(shareSheetViewController, animated: true)
        
    }
    
    private func recipeHeaderLabel(header: String) -> UILabel {
        let label = UILabel()
        label.text = header
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(presentShareSheet))
        
        title = "Recipe"
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(recipeImageView)
        stackView.addArrangedSubview(recipeTitleLabel)
        
        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.addArrangedSubview(recipeReadyInMunutesLabel)
        innerStackView.addArrangedSubview(recipeServingsLabel)
        innerStackView.spacing = 8
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

        recipeImageView.layer.cornerRadius = 5
        recipeImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            recipeImageView.heightAnchor.constraint(equalToConstant: 250),
            
        ])
        
    }
}
