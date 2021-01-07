//
//  PageIndexCollectionViewController.swift
//  LazyPages
//
//  Created by Vargas Casaseca, Cesar on 24.03.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import simd
import UIKit

public protocol PageIndexCollectionViewControllerDataSource: AnyObject {
  /**
   The cell to be shown at the the given index

   - parameter collectionView: the collection view where the index is represented
   - parameter indexPath: the index path of the requested cell
   */
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell

  func sizeForItem(at indexPath: IndexPath) -> CGSize
}

/// This class represents the index of the page controller, a view controller containing a collection view
public class PageIndexCollectionViewController: UIViewController {
  public weak var pageController: PageController?
  public weak var dataSource: PageIndexCollectionViewControllerDataSource?
  @IBOutlet public var collectionView: UICollectionView!

  override public func viewDidLoad() {
    super.viewDidLoad()

    collectionView?.contentInsetAdjustmentBehavior = .never
  }

  func scrollToPosition(around index: CGFloat) {
    guard index >= 0, Int(ceil(index)) < pageController?.numberOfItems ?? 0 else {
      return
    }

    collectionView.contentOffset = contentOffset(around: index)

    let selectedItemIndexPath = IndexPath(item: Int(round(index)), section: 0)
    if !(collectionView.indexPathsForSelectedItems ?? []).contains(selectedItemIndexPath) {
      collectionView.selectItem(at: selectedItemIndexPath, animated: false, scrollPosition: [])
    }
  }

  public func center(to index: Int) {
    collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
  }
}

extension PageIndexCollectionViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    dataSource?.collectionView(collectionView: collectionView, cellForItemAtIndexPath: indexPath as NSIndexPath) ?? UICollectionViewCell()
  }

  public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return pageController?.numberOfItems ?? 0
  }
}

extension PageIndexCollectionViewController: UICollectionViewDelegate {
  public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    handleSelection(at: indexPath)
  }
}

extension PageIndexCollectionViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    dataSource?.sizeForItem(at: indexPath) ?? CGSize.zero
  }
}

private extension PageIndexCollectionViewController {
  func handleSelection(at indexPath: IndexPath) {
    let index = indexPath.row
    pageController?.goTo(index: index, forceRefresh: false)
    center(to: indexPath.row)
  }

  func contentOffset(around index: CGFloat) -> CGPoint {
    let width = collectionView.bounds.width
    let rightBorder = Double(collectionView.contentSize.width - collectionView.bounds.width)
    let fraction = index.truncatingRemainder(dividingBy: 1)
    let path1 = IndexPath(item: Int(floor(index)), section: 0)
    let path2 = IndexPath(item: Int(ceil(index)), section: 0)
    let cellFrame1 = collectionView.layoutAttributesForItem(at: path1)?.frame ?? .zero
    let cellFrame2 = collectionView.layoutAttributesForItem(at: path2)?.frame ?? .zero
    let offset1 = cellFrame1.minX - ((width - cellFrame1.width) / 2.0)
    let offset2 = cellFrame2.minX - ((width - cellFrame2.width) / 2.0)
    let clamped1 = simd_clamp(Double(offset1), 0, rightBorder)
    let clamped2 = simd_clamp(Double(offset2), 0, rightBorder)
    let interpolatedOffset = simd_mix(clamped1, clamped2, Double(fraction))
    let offset = CGPoint(x: interpolatedOffset, y: 0)
    return offset
  }
}
