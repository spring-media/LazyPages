//
//  PageController.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

/// The Data source of the page controller
public protocol PageControllerDataSource: class {
  
  /**
   Asks the data source for a view controller given its index
   
   - parameter index: The index when the view controller should be placed
   
   - returns: The view controller to be shown at the given index
   */
  func viewControllerAtIndex(index: Int) -> UIViewController
  
  /**
   - returns: The number of view controllers to be shown
   */
  func numberOfViewControllers() -> Int
}

/// This view controller contains the page views
public class PageController: UIViewController {
  private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  private var viewControllerCache = [Int: UIViewController]()
  private var currentIndex = 0
  public weak var pageIndexController: PageIndexCollectionViewController?
  
  public weak var dataSource: PageControllerDataSource! {
    didSet {
      let viewController = dataSource.viewControllerAtIndex(0)
      viewController.index = 0
      viewControllerCache[0] = viewController
      pageViewController.setViewControllers([viewController], direction: .Reverse, animated: false, completion: nil)
    }
  }
  
  /// Number of items currently shown
  public var numberOfItems: Int {
    return dataSource.numberOfViewControllers()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    addChildViewController(pageViewController)
    view.addAndPinSubView(pageViewController.view)
  }

  private func viewControllerForIndex(index: Int) -> UIViewController? {
    guard let cachedController = viewControllerCache[index] else {
      let viewController = dataSource.viewControllerAtIndex(index)
      viewController.index = index
      viewControllerCache[index] = viewController
      return viewController
    }
    
    return cachedController
  }
  
  /**
   Moves the page controller to show the given index
   
   - parameter index: The index to move
   */
  public func goToIndex(index: Int) {
    guard let page = viewControllerForIndex(index) else {
      return
    }
    
    let direction: UIPageViewControllerNavigationDirection = index > currentIndex ? .Forward : .Reverse
    
    // Hacky: http://stackoverflow.com/a/18602186/428353
    pageViewController.setViewControllers([page], direction: direction, animated: true, completion: { finished in
      dispatch_async(dispatch_get_main_queue(), {
        self.pageViewController.setViewControllers([page], direction: direction, animated: false, completion: nil)
        self.currentIndex = index
      })
    })
  }
}

extension PageController: UIPageViewControllerDelegate {
  public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let currentIndex = pageViewController.viewControllers?.last?.index where completed else {
      return
    }
    
    self.currentIndex = currentIndex
    
    pageIndexController?.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
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
    
    return viewControllerForIndex(index - 1)
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    guard let numberOfPages = dataSource?.numberOfViewControllers() else {
      return nil
    }
    
    guard let index = viewController.index where index+1 >= 0 && index+1 < numberOfPages else {
      return nil
    }
    
    return viewControllerForIndex(index + 1)
  }
}