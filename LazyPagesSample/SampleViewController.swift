//
//  ViewController.swift
//  LazyPagesSample
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import UIKit
import LazyPages

class SampleViewController: UIViewController {
  fileprivate enum ViewControllerTag {
    case color
    case label
  }
  
  fileprivate enum Segue: String {
    case PageController = "PageControllerSegue"
    case PageIndex = "PageIndexSegue"
  }
  
  fileprivate enum ViewControllerIdentifier: String {
    case Color = "ColorViewController"
    case Label = "LabelViewController"
  }
  
  fileprivate let startIndex = 4
  fileprivate var cachedColors = [Int: UIColor]()
  fileprivate let viewControllersToLoad = [
    ViewControllerTag.color,
    ViewControllerTag.label,
    ViewControllerTag.color,
    ViewControllerTag.label,
    ViewControllerTag.color,
    ViewControllerTag.color,
    ViewControllerTag.label
  ]
  
  weak var pageController: PageController? {
    didSet {
      self.setControllersCoupling()
    }
  }
  
  weak var pageIndex: PageIndexCollectionViewController? {
    didSet {
      self.setControllersCoupling()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pageController?.goToIndex(startIndex)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    guard let segueEnum = Segue(rawValue: identifier) else {
      return
    }
    
    switch segueEnum {
    case .PageController:
      guard let pageController = segue.destination as? PageController else {
        break
      }
      
      self.pageController = pageController
      pageController.dataSource = self
    case .PageIndex:
      guard let pageIndex = segue.destination as? PageIndexCollectionViewController else {
        break
      }
      
      self.pageIndex = pageIndex
      pageIndex.dataSource = self
    }
  }
  
  fileprivate func setControllersCoupling() {
    pageController?.pageIndexController = self.pageIndex
    pageIndex?.pageController = self.pageController
  }
  
  fileprivate func cachedColorFromMap(_ map: inout [Int: UIColor], index: Int) -> UIColor {
    guard let color = map[index] else {
      let newColor = UIColor.randomColor()
      map[index] = newColor
      return newColor
    }
    
    return color
  }
}

extension SampleViewController: PageControllerDataSource {
  func viewControllerAtIndex(_ index: Int) -> UIViewController {
    print("Loading page at index \(index)")
    let viewControllerTag = viewControllersToLoad[index]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewControllerToReturn: UIViewController
    
    switch viewControllerTag {
    case ViewControllerTag.color:
      let colorViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.Color.rawValue) as! ColorViewController
      colorViewController.color = cachedColorFromMap(&cachedColors, index: index)
      viewControllerToReturn = colorViewController
    case ViewControllerTag.label:
      let labelViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.Label.rawValue) as! LabelViewController
      labelViewController.text = "Index \(index)"
      viewControllerToReturn = labelViewController
    }
    
    return viewControllerToReturn
  }
  
  func numberOfViewControllers() -> Int {
    return viewControllersToLoad.count
  }
}

extension SampleViewController: PageIndexCollectionViewControllerDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IndexCollectionViewCell
    cell.indexLabel.text = "\(indexPath.item)"
    return cell
  }
}
