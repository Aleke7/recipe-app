//
//  UILabelExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 13.03.2023.
//

import UIKit

extension UILabel {
    func addDataToLabel(amount: Int, image: UIImage?, for additional: Additional) {
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image?.withTintColor(.systemBlue)
        
        let fullString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: ": \(amount) \(additional.rawValue)"))
        self.attributedText = fullString
    }
}
