//
//  ViewController+Index.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import ObjectiveC
import UIKit

// Declare a global var to produce a unique address as the assoc object handle
var AssociatedObjectHandle: UInt8 = 0

extension UIViewController {
  var index: Int? {
    get {
      return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int
    }
    set {
      objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
