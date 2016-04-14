//
//  UIColor+Random.swift
//  LazyPagesSample
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  /**
   - returns: A random color
   */
  static func randomColor() -> UIColor {
    let randomRed = CGFloat(drand48())
    let randomGreen = CGFloat(drand48())
    let randomBlue = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
  }
}