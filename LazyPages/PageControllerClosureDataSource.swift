//
//  ClosureDataSource.swift
//  LazyPages
//
//  Created by Vargas Casaseca, Cesar on 15.04.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

/// Use this class when you want to create your view controllers by executing a closure by the right index
public final class PageControllerClosureDataSource: PageControllerDataSource {
  fileprivate let closures: [() -> UIViewController]
  
  public init(closures: [() -> UIViewController]) {
    self.closures = closures
  }
  
  public func viewControllerAtIndex(_ index: Int) -> UIViewController {
    return closures[index]()
  }
  
  public func numberOfViewControllers() -> Int {
    return closures.count
  }
}
