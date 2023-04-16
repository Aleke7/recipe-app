//
//  UserDefaultsExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 22.03.2023.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    
    func setObject<Object>(object: Object, forKey: String) throws where Object: Encodable {
        do {
            let data = try JSONEncoder().encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else {
            throw ObjectSavableError.noValue
        }
        do {
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
    func resetDefaults() {
        if let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
            UserDefaults.standard.synchronize()
        }
    }

}
