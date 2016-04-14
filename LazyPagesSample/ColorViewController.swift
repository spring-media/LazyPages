//
//  ColorViewController.swift
//  LazyPagesSample
//
//  Created by Vargas Casaseca, Cesar on 12.04.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

final class ColorViewController: UIViewController {
  var color: UIColor?
  
  @IBOutlet weak var colorView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    colorView.backgroundColor = color
  }
}