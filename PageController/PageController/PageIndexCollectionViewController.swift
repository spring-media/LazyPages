//
//  PageIndexCollectionViewController.swift
//  PageController
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation

public class PageIndexCollectionViewController: UIViewController {
  public var collectionView: UICollectionView? {
    didSet {
      guard let collectionView = collectionView else {
        return
      }
      
      view.addAndPinSubView(collectionView)
    }
  }
}