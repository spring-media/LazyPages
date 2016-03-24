//
//  ViewController.swift
//  PageControllerSample
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import UIKit
import PageController

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let pageController = segue.destinationViewController as? PageController {
      pageController.dataSource = self
    }
  }
  
  
}

extension ViewController: PageControllerDataSource {
  func viewControllerAtIndex(index: Int) -> UIViewController {
    print("request view controller for index \(index)")
    let viewController = UIViewController()
    viewController.view.backgroundColor = UIColor.randomColor()
    return viewController
  }
  
  func numberOfViewControllers() -> Int {
    return 5
  }
}

