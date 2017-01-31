//
//  UIView+Autolayout.swift
//  LazyPages
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  /**
   Adds the subview to the view, adjusting its edges to self
   
   - parameter subView: The view to be added an pinned
   */
  func addAndPinSubView(_ subView: UIView) {
    self.addSubview(subView)
    
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["subView"] = subView
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
      options: [], metrics: nil, views: viewBindingsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
      options: [], metrics: nil, views: viewBindingsDict))
  }
}
