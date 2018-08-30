//
//  UIViewControllerExtensions.swift
//  PanSongs
//
//  Created by betraying on 8/30/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

extension UIViewController {
  
  class func instance() -> Self {
    return UIStoryboard.viewController(type: self)
  }
}
