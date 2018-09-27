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
    setupEditButton()
    setupTextView()
    setupFrameChordView()
    setStatusBarBackgroundColor(color: .background)
    
    view.addSubview(chordView)
  }
  
  private func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
  }
  
  @IBAction func testAction(_ sender: Any) {
    print(FirebaseManager.shared.send(song: song!))
  }
  
  
  private func setupTextView() {
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
    
    let screenHeight = UIScreen.main.bounds.height
    let navigationBarHeight = (navigationController?.navigationBar.frame.height)!
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let bottomInset: CGFloat = 20
    
    chordView.center.y = screenHeight - chordView.frame.height / 2 - navigationBarHeight - statusBarHeight - bottomInset
  }
  
  private func setupEditButton () {
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
    let songVC = SongViewController.instance()
    songVC.song = song
    navigationController?.pushViewController(songVC, animated: true)
  }
}
extension DetailSongViewController: ChordTextViewDelegate, PresentChordViewDelegate {
  
  func closeChordView() {}
  func textViewDidChange() {}
  
  func clickOn(chord: Chord) {
    chordView.chord = chord
    chordView.isHidden = false
  }
}


