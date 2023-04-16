//
//  UISwitchExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 27.03.2023.
//

import UIKit

@available (iOS 14.0, *)
extension UISwitch {
    
    func setOnValueChangedListener(onValueChanged: @escaping () -> Void) {
        self.addAction(UIAction() { action in
            onValueChanged()
        }, for: .valueChanged)
    }
    
}
