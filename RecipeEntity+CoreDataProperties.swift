//
//  RecipeEntity+CoreDataProperties.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 08.04.2023.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var image: String?
    @NSManaged public var instructions: String?
    @NSManaged public var readyInMinutes: Int16
    @NSManaged public var recipeId: Int16
    @NSManaged public var servings: Int16
    @NSManaged public var sourceUrl: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var extendedIngredient: NSSet?

}

// MARK: Generated accessors for extendedIngredient
extension RecipeEntity {

    @objc(addExtendedIngredientObject:)
    @NSManaged public func addToExtendedIngredient(_ value: ExtendedIngredientEntity)

    @objc(removeExtendedIngredientObject:)
    @NSManaged public func removeFromExtendedIngredient(_ value: ExtendedIngredientEntity)

    @objc(addExtendedIngredient:)
    @NSManaged public func addToExtendedIngredient(_ values: NSSet)

    @objc(removeExtendedIngredient:)
    @NSManaged public func removeFromExtendedIngredient(_ values: NSSet)

}

extension RecipeEntity : Identifiable {

}
