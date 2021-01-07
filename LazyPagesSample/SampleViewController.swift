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
  
  private let startIndex = 4
  private var cachedColors = [Int: UIColor]()
  private let viewControllersToLoad = [
    ViewControllerTag.Color,
    ViewControllerTag.Label,
    ViewControllerTag.Color,
    ViewControllerTag.Label,
    ViewControllerTag.Color,
    ViewControllerTag.Color,
    ViewControllerTag.Label
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
  
  private func setControllersCoupling() {
    pageController?.pageIndexController = self.pageIndex
    pageIndex?.pageController = self.pageController
  }
  
  private func cachedColorFromMap( map: inout [Int: UIColor], index: Int) -> UIColor {
    guard let color = map[index] else {
      let newColor = UIColor.randomColor()
      map[index] = newColor
      return newColor
    }
    
    return color
  }
}

extension SampleViewController: PageControllerDataSource {
  func viewControllerAtIndex(index: Int) -> UIViewController {
    let viewControllerTag = viewControllersToLoad[index]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewControllerToReturn: UIViewController
    
    switch viewControllerTag {
    case ViewControllerTag.Color:
      let colorViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.Color.rawValue) as! ColorViewController
      colorViewController.color = cachedColorFromMap(map: &cachedColors, index: index)
      viewControllerToReturn = colorViewController
    case ViewControllerTag.Label:
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
  func sizeForItem(at indexPath: IndexPath) -> CGSize {
    CGSize(width: 100, height: 30)
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! IndexCollectionViewCell
    cell.indexLabel.text = "\(indexPath.item)"
    return cell
  }
}
