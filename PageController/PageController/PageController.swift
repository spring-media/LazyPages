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
  private var currentIndex = 0
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
    pageViewController.delegate = self
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
    
    let direction: UIPageViewControllerNavigationDirection = index > currentIndex ? .Forward : .Reverse
    
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
    if !completed {
      return
    }
    
    guard let currentIndex = pageViewController.viewControllers?.last?.index else {
      return
    }
    
    self.currentIndex = currentIndex
    
    pageIndex?.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
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
    let index = indexPath.row
    if index != currentIndex {
      goToIndex(index)
      pageIndex?.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
  }
}