//
//  UICollectionViewExtension.swift
//  PanSongs
//
//  Created by Godjira on 8/23/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func scrollToLastIndexPath(position: UICollectionViewScrollPosition, animated: Bool) {
        self.layoutIfNeeded()
        
        for sectionIndex in (0..<self.numberOfSections).reversed() {
            if self.numberOfItems(inSection: sectionIndex) > 0 {
                self.scrollToItem(at: IndexPath.init(item: self.numberOfItems(inSection: sectionIndex)-1, section: sectionIndex),
                                  at: position,
                                  animated: animated)
                break
            }
        }
    }
    
}
