//
//  IndexCollectionViewCell.swift
//  LazyPagesSample
//
//  Created by Vargas Casaseca, Cesar on 13.04.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

final class IndexCollectionViewCell: UICollectionViewCell {
   @IBOutlet weak var indexLabel: UILabel!
  
  override var selected: Bool {
    didSet {
      if selected {
        backgroundColor = UIColor.grayColor()
        indexLabel.textColor = UIColor.whiteColor()
      } else {
        backgroundColor = UIColor.whiteColor()
        indexLabel.textColor = UIColor.blackColor()
      }
    }
  }
}