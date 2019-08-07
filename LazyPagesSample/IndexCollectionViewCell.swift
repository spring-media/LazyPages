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
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        backgroundColor = UIColor.gray
        indexLabel.textColor = UIColor.white
      } else {
        backgroundColor = UIColor.white
        indexLabel.textColor = UIColor.black
      }
    }
  }
}
