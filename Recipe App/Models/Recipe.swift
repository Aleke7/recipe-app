//
//  Meal.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 10.03.2023.
//

import Foundation

struct Recipe: Codable {
    
    private enum CodingKeys: CodingKey {
        case id
        case title
        case readyInMinutes
        case servings
        case sourceUrl
        case image
        case summary
        case extendedIngredients
        case instructions
    }
    
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String?
    let summary: String
    let extendedIngredients: [ExtendedIngredient]
    let instructions: String
    var isFavorite: Bool = false
    
}

struct ExtendedIngredient: Codable {
    let id: Int
    let name: String
    let amount: Double
    let unit: String
}

