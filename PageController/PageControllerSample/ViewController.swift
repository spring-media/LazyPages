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
  private enum ViewControllerTag {
    case Color
    case Label
  }
  
  private enum Segue: String {
    case PageController = "PageControllerSegue"
    case PageIndex = "PageIndexSegue"
  }
  
  private enum ViewControllerIdentifier: String {
    case Color = "ColorViewController"
    case Label = "LabelViewController"
  }
  
  var cachedColors = [Int: UIColor]()
  private let viewControllersToLoad = [
    ViewControllerTag.Color,
    ViewControllerTag.Label,
    ViewControllerTag.Color,
    ViewControllerTag.Label,
    ViewControllerTag.Label,
    ViewControllerTag.Color,
    ViewControllerTag.Label
  ]
  
  weak var pageController: PageController? {
    didSet {
      pageController?.pageIndexController = self.pageIndex
      pageIndex?.pageController = self.pageController
    }
  }
  
  weak var pageIndex: PageIndexCollectionViewController? {
    didSet {
      pageController?.pageIndexController = self.pageIndex
      pageIndex?.pageController = self.pageController
    }
  }

  override func viewDidLoad() {
     super.viewDidLoad()
    
    pageController?.goToIndex(6)
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
      pageIndex.dataSource = self
    }
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
    print("Loading page at index \(index)")
    let viewControllerTag = viewControllersToLoad[index]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewControllerToReturn: UIViewController
    
    switch viewControllerTag {
    case ViewControllerTag.Color:
      let colorViewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.Color.rawValue) as! ColorViewController
      let v = colorViewController.view
      colorViewController.colorView.backgroundColor = cachedColorFromMap(&cachedColors, index: index)
      viewControllerToReturn = colorViewController
    case ViewControllerTag.Label:
      let labelViewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.Label.rawValue) as! LabelViewController
      let v = labelViewController.view
      labelViewController.label.text = "Index \(index)"
      viewControllerToReturn = labelViewController
    }
    
    return viewControllerToReturn
  }
  
  func numberOfViewControllers() -> Int {
    return viewControllersToLoad.count
  }
}

extension ViewController: PageIndexCollectionViewControllerDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)

    cell.backgroundColor = cachedColorFromMap(&cachedColors, index: indexPath.row)
    return cell
  }
}
