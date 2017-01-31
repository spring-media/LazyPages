//
//  ArrayDataSource.swift
//  LazyPages
//
//  Created by Vargas Casaseca, Cesar on 15.04.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

/// Use this class when you want to create the Page Controller with all the view controllers initialised from the start
public final class PageControllerArrayDataSource: PageControllerDataSource {
  fileprivate let viewControllers: [UIViewController]
  
  public init(viewControllers: [UIViewController]) {
    self.viewControllers = viewControllers
  }
  
  public func viewControllerAtIndex(_ index: Int) -> UIViewController {
    return viewControllers[index]
  }
  
  public func numberOfViewControllers() -> Int {
    return viewControllers.count
  }
}
