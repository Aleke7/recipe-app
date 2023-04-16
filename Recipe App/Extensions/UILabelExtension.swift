//
//  UILabelExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 13.03.2023.
//

import UIKit

enum Additional: String {
    case minutes
    case servings
    case price
}

extension UILabel {
    func imagePlusText(amount: String, image: UIImage?, for additional: Additional) {
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image?.withTintColor(.systemBlue)
        
        let fullString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: ": \(amount) \(additional.rawValue)"))
        self.attributedText = fullString
    }
    
    func textPlusImage(amount: String, image: UIImage?, for additional: Additional) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image?.withTintColor(.systemBlue)
        
        let fullString = NSMutableAttributedString(string: "\(amount)")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " per serving"))
        self.attributedText = fullString
    }
    
}
