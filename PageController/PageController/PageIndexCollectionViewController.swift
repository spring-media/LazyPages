//
//  PageIndexCollectionViewController.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

public protocol PageIndexCollectionViewControllerDataSource: class {
  /**
   The cell to be shown at the the given index
   
   - parameter collectionView: the collection view where the index is represented
   - parameter indexPath: the index path of the requested cell
   */
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
}

/// This class represents the index of the page controller, a view controller containing a collection view
public class PageIndexCollectionViewController: UIViewController {
  public weak var pageController: PageController?
  public weak var dataSource: PageIndexCollectionViewControllerDataSource?
  
  @IBOutlet public weak var collectionView: UICollectionView!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension PageIndexCollectionViewController: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    assert(pageController != nil, "The page controller reference in the PageIndexCollectionViewController cannot be nil")
    return pageController!.numberOfItems
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