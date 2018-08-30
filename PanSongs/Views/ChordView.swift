//
//  ChordView.swift
//  PanSongs
//
//  Created by Godjira on 8/18/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

protocol PresentChordViewDelegate {
  func closeChordView()
}

class ChordView: UIView {
  
  @IBOutlet weak var chordLabel: UILabel!
  @IBOutlet weak var chordNameLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var chord: Chord? {
    didSet {
      guard let chord = chord else { return }
      pageControl.numberOfPages = chord.chordStruct.positions.count
      chordNameLabel.text = chord.chordStruct.name
      chordLabel.text = chord.currentVatiations.first
    }
  }
  var closeDelegat: PresentChordViewDelegate?
  
  override func awakeFromNib() {
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ChordView.respondToSwipeGesture(gesture:)) )
    swipeRight.direction = .right
    chordLabel.addGestureRecognizer(swipeRight)
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ChordView.respondToSwipeGesture(gesture:)) )
    swipeLeft.direction = .left
    
    chordLabel.addGestureRecognizer(swipeLeft)
  }
  
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case .right:
        if pageControl.currentPage == 0 {
          pageControl.currentPage = chord!.chordStruct.positions.count
        } else {
          pageControl.currentPage = pageControl.currentPage - 1
        }
        chord?.prevChordPosition()
        chordLabel.text = chord?.currentVatiations.first
      case .left:
        chord?.nextChordPosition()
        chordLabel.text = chord?.currentVatiations.first
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
          pageControl.currentPage = 0
        } else {
          pageControl.currentPage = pageControl.currentPage + 1
        }
      default:
        break
      }
    }
  }
  
  @IBAction func closeButtonAction(_ sender: Any) {
    self.isHidden = true
  }
}


