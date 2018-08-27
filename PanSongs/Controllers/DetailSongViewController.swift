//
//  DetailSongViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/16/18.
//  Copyright © 2018 pangolier. All rights reserved.
//
import Foundation
import UIKit
class DetailSongViewController: UIViewController {
  
  @IBOutlet weak var textView: ChordTextView!
  @IBOutlet var chordView: ChordView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var song: Song?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initEditButton()
    initTextView()
    view.addSubview(chordView)
    chordView.isHidden = true
    chordView.center.x = UIScreen.main.bounds.width / 2
    chordView.center.y = UIScreen.main.bounds.height - chordView.frame.height / 2 - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height
    setFrameAndContentSize()
  }
  
  private func setFrameAndContentSize() {
    scrollView.frame = CGRect(x: CGFloat(0),
                              y: CGFloat(0),
                              width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height)
    textView.frame = CGRect(x: CGFloat(0),
                            y: CGFloat(0),
                            width: CGFloat(song!.widthTextView),
                            height: UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height)
    
    scrollView.contentSize.height = textView.contentSize.height
    scrollView.contentSize.width = CGFloat(song!.widthTextView)
  }
  
  private func initTextView() {
    textView.isEditable = false
    textView.isSelectable = true
    textView.isUserInteractionEnabled = true
    textView.isScrollEnabled = true
    textView.delegateChordTextView = self
    textView.delegate = textView
    textView.attributedText = song?.textTextView
  }
  
  private func initEditButton () {
    let editImage = UIImage(named: "editIcon.png")?.withRenderingMode(.alwaysTemplate)
    let imageView = UIImageView(image: editImage)
    imageView.tintColor = .background2
    imageView.contentMode = .scaleAspectFit
    let centerButton =  UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    imageView.frame = centerButton.bounds
    centerButton.addSubview(imageView)
    imageView.isUserInteractionEnabled = true
    let gestrueTapCircleButton = UITapGestureRecognizer(target: self, action: #selector(DetailSongViewController.editButtonAction))
    imageView.addGestureRecognizer(gestrueTapCircleButton)
    self.navigationItem.titleView = centerButton
  }
  
  @objc func editButtonAction() {
    guard let songVC = storyboard?.instantiateViewController(withIdentifier: "SongViewController") as? SongViewController else { return }
    songVC.song = song
    navigationController?.pushViewController(songVC, animated: true)
  }
  
}
extension DetailSongViewController: ChordTextViewDelegate, PresentChordViewDelegate {
  
  func closeChordView() {
//    scrollView.contentInset = .zero
//    scrollView.scrollIndicatorInsets = .zero
  }
  
  func clickOn(chord: Chord) {
    chordView.setChord(chord: chord)
    chordView.isHidden = false
//    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: chordView.frame.height, right: 0)
//    scrollView.contentInset = contentInsets
//    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  func textViewDidChange() {
    textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
    scrollView.contentSize.height = textView.contentSize.height
    scrollView.contentSize.width = textView.contentSize.width
  }
}
