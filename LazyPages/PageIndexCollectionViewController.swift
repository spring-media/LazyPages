//
//  PageIndexCollectionViewController.swift
//  LazyPages
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
  func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
}

/// This class represents the index of the page controller, a view controller containing a collection view
open class PageIndexCollectionViewController: UIViewController {
  open weak var pageController: PageController?
  open weak var dataSource: PageIndexCollectionViewControllerDataSource?
  
  @IBOutlet open weak var collectionView: UICollectionView!
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension PageIndexCollectionViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    assert(pageController != nil, "The page controller reference in the PageIndexCollectionViewController cannot be nil")
    return pageController!.numberOfItems
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    assert(dataSource != nil, "The data source of the PageIndexCollectionViewController cannot be nil")
    return dataSource!.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
  }
}

extension PageIndexCollectionViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.row
    pageController?.goToIndex(index)
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
