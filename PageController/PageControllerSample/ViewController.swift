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
  private enum Segue: String {
    case PageController = "PageControllerSegue"
    case PageIndex = "PageIndexSegue"
  }
  
  var cachedColors = [Int: UIColor]()
  let viewControllersNumber = 12
  
  weak var pageController: PageController? {
    didSet {
      pageController?.pageIndex = self.pageIndex
      pageIndex?.pageController = self.pageController
    }
  }
  
  weak var pageIndex: PageIndexCollectionViewController? {
    didSet {
      pageController?.pageIndex = self.pageIndex
      pageIndex?.pageController = self.pageController
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    guard let segueEnum = Segue(rawValue: identifier) else {
      return
    }
    
    switch segueEnum {
    case .PageController:
      guard let pageController = segue.destinationViewController as? PageController else {
        break
      }
      
      self.pageController = pageController
      pageController.dataSource = self
    case .PageIndex:
      guard let pageIndex = segue.destinationViewController as? PageIndexCollectionViewController else {
        break
      }
      
      self.pageIndex = pageIndex
      configurePageIndexViewController(pageIndex)
    }
  }
  
  private func configurePageIndexViewController(pageIndex: PageIndexCollectionViewController) {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    let collectionView = UICollectionView(frame: pageIndex.view.frame, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    //collectionView.delegate = self
    collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = UIColor.redColor()
    
    pageIndex.collectionView = collectionView
  }
  
  private func cachedColorFromMap(inout map: [Int: UIColor], index: Int) -> UIColor {
    guard let color = map[index] else {
      let newColor = UIColor.randomColor()
      map[index] = newColor
      return newColor
    }
    
    return color
  }
}

extension ViewController: PageControllerDataSource {
  func viewControllerAtIndex(index: Int) -> UIViewController {
    print("request view controller for index \(index)")
    let viewController = UIViewController()
    viewController.view.backgroundColor = cachedColorFromMap(&cachedColors, index: index)
    return viewController
  }
  
  func numberOfViewControllers() -> Int {
    return viewControllersNumber
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewControllersNumber
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)

    cell.backgroundColor = cachedColorFromMap(&cachedColors, index: indexPath.row)
    return cell
  }
}
