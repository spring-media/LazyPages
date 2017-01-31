//
//  PageController.swift
//  LazyPages
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
  func viewControllerAtIndex(_ index: Int) -> UIViewController
  
  /**
   - returns: The number of view controllers to be shown
   */
  func numberOfViewControllers() -> Int
}

/// This view controller contains the page views
open class PageController: UIViewController {
  fileprivate let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  fileprivate var viewControllerCache = [Int: UIViewController]()
  fileprivate var currentIndex = 0
  open weak var pageIndexController: PageIndexCollectionViewController?
  
  open weak var dataSource: PageControllerDataSource! {
    didSet {
      let viewController = dataSource.viewControllerAtIndex(0)
      viewController.index = 0
      viewControllerCache[0] = viewController
      pageViewController.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
    }
  }
  
  /// Number of items currently shown
  open var numberOfItems: Int {
    return dataSource.numberOfViewControllers()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    viewControllerCache = [:]
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    addChildViewController(pageViewController)
    view.addAndPinSubView(pageViewController.view)
  }

  fileprivate func viewControllerForIndex(_ index: Int) -> UIViewController? {
    guard let numberOfPages = dataSource?.numberOfViewControllers(), index >= 0 && index < numberOfPages  else {
      return nil
    }
    
    guard let cachedController = viewControllerCache[index] else {
      let viewController = dataSource.viewControllerAtIndex(index)
      viewController.index = index
      viewControllerCache[index] = viewController
      return viewController
    }
    
    return cachedController
  }
  
  /**
   Moves the page controller to show the given index. The index view also scrolls to the desired index. 
   
   - parameter index: The index to move
   */
  open func goToIndex(_ index: Int) {
    guard let page = viewControllerForIndex(index) else {
      return
    }
    
    let direction: UIPageViewControllerNavigationDirection = index > currentIndex ? .forward : .reverse
    
    // Hacky: http://stackoverflow.com/a/18602186/428353
    pageViewController.setViewControllers([page], direction: direction, animated: true, completion: { finished in
      DispatchQueue.main.async(execute: {
        self.pageViewController.setViewControllers([page], direction: direction, animated: false, completion: nil)
        self.currentIndex = index
        self.pageIndexController?.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
      })
    })
  }
}

extension PageController: UIPageViewControllerDelegate {
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let currentIndex = pageViewController.viewControllers?.last?.index, completed else {
      return
    }
    
    self.currentIndex = currentIndex
    
    pageIndexController?.collectionView?.selectItem(at: IndexPath(row: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
  }
}

extension PageController: UIPageViewControllerDataSource {
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewController.index else {
      return nil
    }

    return viewControllerForIndex(index - 1)
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewController.index else {
      return nil
    }
    
    return viewControllerForIndex(index + 1)
  }
}
