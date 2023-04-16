//
//  ExtendedIngredientEntity+CoreDataProperties.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 08.04.2023.
//
//

import Foundation
import CoreData


extension ExtendedIngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExtendedIngredientEntity> {
        return NSFetchRequest<ExtendedIngredientEntity>(entityName: "ExtendedIngredientEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var unit: String?
    @NSManaged public var recipe: RecipeEntity?

}

extension ExtendedIngredientEntity : Identifiable {

}
