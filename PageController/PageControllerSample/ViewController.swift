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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let pageController = segue.destinationViewController as? PageController {
      pageController.dataSource = self
    }
  }
  
  private func randomColor() -> UIColor {
    let randomRed = CGFloat(drand48())
    let randomGreen = CGFloat(drand48())
    let randomBlue = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
  }
}

extension ViewController: PageControllerDataSource {
  func viewControllerAtIndex(index: Int) -> UIViewController {
    print("request view controller for index \(index)")
    let viewController = UIViewController()
    viewController.view.backgroundColor = randomColor()
    return viewController
  }
  
  func numberOfViewControllers() -> Int {
    return 5
  }
}

