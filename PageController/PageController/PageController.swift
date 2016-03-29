//
//  PageController.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

public protocol PageControllerDataSource: class {
  func viewControllerAtIndex(index: Int) -> UIViewController
  
  func numberOfViewControllers() -> Int
}

public class PageController: UIViewController {
  private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  private var viewControllerCache = [Int: UIViewController]()
  public weak var pageIndex: PageIndexCollectionViewController? {
    didSet {
      pageIndex?.collectionView?.delegate = self
    }
  }
  
  public weak var dataSource: PageControllerDataSource? {
    didSet {
      let viewController = dataSource!.viewControllerAtIndex(0)
      viewController.index = 0
      viewControllerCache[0] = viewController
      pageViewController.setViewControllers([viewController], direction: .Reverse, animated: false, completion: nil)
    }
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    pageViewController.dataSource = self
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    addChildViewController(pageViewController)
    view.addAndPinSubView(pageViewController.view)
  }

  private func viewControllerForIndex(index: Int, inout cache: [Int: UIViewController], dataSource: PageControllerDataSource?) -> UIViewController? {
    guard let cachedController = viewControllerCache[index] else {
      let viewController = dataSource?.viewControllerAtIndex(index)
      viewController?.index = index
      cache[index] = viewController
      return viewController
    }
    
    return cachedController
  }
  
  private func goToIndex(index: Int) {
    guard let page = viewControllerForIndex(index, cache: &viewControllerCache, dataSource: dataSource) else {
      return
    }
    pageViewController.setViewControllers([page], direction: .Forward, animated: true, completion: { finished in
      dispatch_async(dispatch_get_main_queue(), {
        self.pageViewController.setViewControllers([page], direction: .Forward, animated: false, completion: nil)
      })
    })
  }
}

extension PageController: UIPageViewControllerDataSource {
  public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    guard let numberOfPages = dataSource?.numberOfViewControllers() else {
      return nil
    }
    
    guard let index = viewController.index where index-1 >= 0 && index-1 < numberOfPages else {
      return nil
    }
    
    return viewControllerForIndex(index - 1, cache: &viewControllerCache, dataSource: dataSource)
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    guard let numberOfPages = dataSource?.numberOfViewControllers() else {
      return nil
    }
    
    guard let index = viewController.index where index+1 >= 0 && index+1 < numberOfPages else {
      return nil
    }
    
    return viewControllerForIndex(index + 1, cache: &viewControllerCache, dataSource: dataSource)
  }
}

extension PageController: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    goToIndex(indexPath.row)
  
  }
}