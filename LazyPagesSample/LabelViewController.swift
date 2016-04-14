//
//  LabelViewController.swift
//  LazyPagesSample
//
//  Created by Vargas Casaseca, Cesar on 12.04.16.
//  Copyright © 2016 WeltN24. All rights reserved.
//

import Foundation
import UIKit

final class LabelViewController: UIViewController {
  var text: String?
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = text
  }
}