//
//  StringExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 15.03.2023.
//

import UIKit

enum Position {
    case start
    case end
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension String {
    
    var capitalizedSentence: String {
            let firstLetter = self.prefix(1).capitalized
            let remainingLetters = self.dropFirst().lowercased()
            return firstLetter + remainingLetters
        }
    
}
