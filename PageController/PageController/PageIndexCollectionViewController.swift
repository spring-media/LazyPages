//
//  PageIndexCollectionViewController.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation

public protocol PageIndexCollectionViewControllerDataSource: class {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
}

public class PageIndexCollectionViewController: UIViewController {
  
  public weak var pageController: PageController?
  public weak var dataSource: PageIndexCollectionViewControllerDataSource?
  
  public var collectionView: UICollectionView? {
    didSet {
      guard let collectionView = collectionView else {
        return
      }
      
      view.addAndPinSubView(collectionView)
    }
  }
  
  public override func viewDidLoad() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    let initializatingCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    initializatingCollectionView.translatesAutoresizingMaskIntoConstraints = false
    initializatingCollectionView.dataSource = self
    initializatingCollectionView.delegate = self
    self.collectionView = initializatingCollectionView
  }
}

extension PageIndexCollectionViewController: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    assert(pageController != nil, "The page controller reference in the PageIndexCollectionViewController cannot be nil")
    return pageController!.numberOfItems!
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    assert(dataSource != nil, "The data source of the PageIndexCollectionViewController cannot be nil")
    return dataSource!.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
  }
}

extension PageIndexCollectionViewController: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let index = indexPath.row
    pageController?.goToIndex(index)
    collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
  }
}