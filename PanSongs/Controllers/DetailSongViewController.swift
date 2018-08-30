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
    setupFrameChordView()
    setStatusBarBackgroundColor(color: .background)
    
  }

  private func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
  }
  
  private func initTextView() {
    textView.isEditable = false
    textView.isSelectable = true
    textView.isUserInteractionEnabled = true
    textView.isScrollEnabled = true
    textView.delegateChordTextView = self
    textView.delegate = textView
    setupFrameTextView()
  }
  
  private func setupFrameTextView() {
    textView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 2000, height: 3000))
    textView.attributedText = song?.textTextView
    textView.layoutIfNeeded()
    guard let widthTextView: CGFloat = CGFloat(song!.widthTextView) else { return }
    let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
    scrollView.contentSize.height = contentSize.height
    if contentSize.width > UIScreen.main.bounds.width {
      scrollView.contentSize.width = contentSize.width
    } else {
      scrollView.contentSize.width = UIScreen.main.bounds.width
    }
  }
  
  
  private func setupFrameChordView() {
    chordView.isHidden = true
    chordView.center.x = UIScreen.main.bounds.width / 2
    chordView.center.y = UIScreen.main.bounds.height - chordView.frame.height / 2 - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - CGFloat(20)
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

  }
  
  func clickOn(chord: Chord) {
    chordView.setChord(chord: chord)
    chordView.isHidden = false
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: chordView.frame.height, right: 0)
  }
  
  func textViewDidChange() {

  }
}
