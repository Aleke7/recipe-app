//
//  RecipeAPI.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 10.03.2023.
//

import Foundation

class NetworkClient {
    
    static let API_KEY = "37fa00d523484bc09de29543a1d5b58d"
    static let url = "https://api.spoonacular.com/recipes/random/?apiKey=\(API_KEY)&number=100"
    
    static let shared = NetworkClient()
    
    var recipes = Response(recipes: [])
    
    func getData(completion: @escaping () -> Void) {
        guard let url = URL(string: NetworkClient.url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Something went wrong")
                completion()
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Something went wrong")
                return
            }
            
            if
                response.statusCode == 200,
                let data,
                let recipes = try? JSONDecoder().decode(Response.self, from: data)
            {
                self.recipes = recipes
                print("Not went wrong")
                completion()
            }
        }
        
        task.resume()
    }
}

