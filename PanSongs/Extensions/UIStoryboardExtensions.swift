//
//  UIStoryboardExtensions.swift
//  PanSongs
//
//  Created by betraying on 8/30/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

extension UIStoryboard {
  
  class func viewController<T: UIViewController>(type: T.Type) -> T {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
  }
}
