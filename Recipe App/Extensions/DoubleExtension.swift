//
//  DoubleExtension.swift
//  Recipe App
//
//  Created by Almat Begaidarov on 27.03.2023.
//

import Foundation

typealias Rational = (num: Int, den: Int)

extension Double {
    
    func rationalApproximationOf(withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = self
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0 / (x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
}
