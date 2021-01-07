//
//  PageController.swift
//  LazyPages
//
//  Created by Vargas Casaseca, Cesar on 23.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

public protocol PageControllerDelegate: AnyObject {
  func didTransitionToView(at index: Int)
}

/// The Data source of the page controller
public protocol PageControllerDataSource: AnyObject {
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
  private lazy var pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    addChild(pageViewController)
    view.addAndPinSubView(subView: pageViewController.view)
    pageViewController.didMove(toParent: self)

    return pageViewController
  }()

  private let cachingNeighborsCount = 2
  private var viewControllerCache = [Int: UIViewController]()
  public var currentIndex = 0
  public weak var pageIndexController: PageIndexCollectionViewController?
  public var currentlyDisplayedViewController: UIViewController? {
    viewControllerCache[currentIndex]
  }

  public weak var dataSource: PageControllerDataSource! {
    didSet {
      DispatchQueue.main.async {
        self.setup()
      }
    }
  }

  public weak var delegate: PageControllerDelegate?

  private func setup() {
    guard let viewController = viewControllerForIndex(index: 0) else {
      return
    }
    viewController.index = 0
    viewControllerCache[0] = viewController
    pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
    delegate?.didTransitionToView(at: currentIndex)

    pageIndexController?.collectionView.reloadData()
    pageIndexController?.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)

    updateCache(currentIndex: 0)
  }

  /// Number of items currently shown
  public var numberOfItems: Int {
    dataSource?.numberOfViewControllers() ?? 0
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    clearCache()
  }

  private func clearCache() {
    viewControllerCache = [:]
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    setScrollViewDelegate(self)
  }

  private func setScrollViewDelegate(_ delegate: UIScrollViewDelegate?) {
    for subview in pageViewController.view.subviews {
      if let scrollView = subview as? UIScrollView {
        scrollView.delegate = delegate
        return
      }
    }
  }

  private func viewControllerForIndex(index: Int) -> UIViewController? {
    guard let numberOfPages = dataSource?.numberOfViewControllers(), index >= 0, index < numberOfPages else {
      return nil
    }

    guard let cachedController = viewControllerCache[index] else {
      let viewController = dataSource.viewControllerAtIndex(index: index)
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
  public func goTo(index: Int, animated: Bool = true, forceRefresh: Bool = true) {
    guard let page = viewControllerForIndex(index: index) else {
      return
    }

    updateCache(currentIndex: index)

    guard index != currentIndex ||
      forceRefresh else {
      handleNavigation(to: index)
      return
    }

    let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse

    // Hacky: http://stackoverflow.com/a/18602186/428353
    setScrollViewDelegate(nil)
    page.view.alpha = 1.0
    pageViewController.setViewControllers([page], direction: direction, animated: animated, completion: { _ in
      DispatchQueue.main.async {
        self.pageIndexController?.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.handleNavigation(to: index)
        self.setScrollViewDelegate(self)
      }
    })
  }

  private func updateCache(currentIndex index: Int) {
    preloadNeighborsIfRequired(currentIndex: index)
    removeOldViewControllersFromCache(currentIndex: index)
  }

  private func preloadNeighborsIfRequired(currentIndex: Int) {
    (currentIndex - cachingNeighborsCount...currentIndex + cachingNeighborsCount)
      .filter { $0 != index }
      .forEach {
        preloadViewControllerIfRequired(at: $0)
      }
  }

  private func removeOldViewControllersFromCache(currentIndex: Int) {
    let validCachingIndexesRange = (currentIndex - cachingNeighborsCount)...(currentIndex + cachingNeighborsCount)
    let deletingViewControllersKeys = viewControllerCache.keys.filter { !validCachingIndexesRange.contains($0) }

    deletingViewControllersKeys
      .compactMap { viewControllerCache[$0] }
      .forEach {
        $0.willMove(toParent: nil)
        $0.view.removeFromSuperview()
        $0.removeFromParent()
      }

    deletingViewControllersKeys.forEach {
      viewControllerCache[$0] = nil
    }
  }

  private func preloadViewControllerIfRequired(at index: Int) {
    guard let numberOfPages = dataSource?.numberOfViewControllers(), index >= 0, index < numberOfPages else {
      return
    }

    guard viewControllerCache[index] == nil else {
      return
    }

    let viewController = preloadViewController(at: index)
    viewControllerCache[index] = viewController
  }

  private func preloadViewController(at index: Int) -> UIViewController {
    // Hacky: Parks the viewcontroller on screen invisibly in order to prevent stuttering during scrolling
    let viewController = dataSource.viewControllerAtIndex(index: index)
    viewController.view.alpha = 0.001
    viewController.index = index
    view.insertSubview(viewController.view, at: 0)
    addChild(viewController)
    viewController.didMove(toParent: self)
    return viewController
  }

  private func handleNavigation(to index: Int) {
    currentIndex = index
    delegate?.didTransitionToView(at: currentIndex)
  }

  public func reloadData() {
    clearCache()
    goTo(index: currentIndex, animated: false)
  }
}

extension PageController: UIPageViewControllerDelegate {
  public func pageViewController(_: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    pendingViewControllers.forEach { $0.view.alpha = 1.0 } // see preloadViewControllerIfRequired() for why this is here!
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating _: Bool,
    previousViewControllers _: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard let currentIndex = pageViewController.viewControllers?.last?.index, completed else {
      return
    }

    handleNavigation(to: currentIndex)
    updateCache(currentIndex: currentIndex)
  }
}

extension PageController: UIPageViewControllerDataSource {
  public func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewController.index else {
      return nil
    }

    return viewControllerForIndex(index: index - 1)
  }

  public func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewController.index else {
      return nil
    }

    return viewControllerForIndex(index: index + 1)
  }
}

extension PageController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.width
    let index = CGFloat(currentIndex)
    let relativeOffset = scrollView.contentOffset.x.truncatingRemainder(dividingBy: width)
    let pageFraction = relativeOffset / width
    let floatIndex = scrollView.contentOffset.x >= width ? index + pageFraction : index - (1.0 - pageFraction)
    pageIndexController?.scrollToPosition(around: floatIndex)
  }
}
