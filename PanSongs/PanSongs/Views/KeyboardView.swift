//
//  KeyboardViewController.swift
//  PanSongs
//
//  Created by betraying on 7/31/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

protocol SendDelegate: class {
  func send(text: String)
}

class KeyboardView: UIView {
  
  weak var delegate: SendDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  @IBAction func action(_ sender: UIButton) {
    delegate?.send(text: "hey")
  }
}
