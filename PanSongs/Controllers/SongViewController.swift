//
//  SongViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/14/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class SongViewController: UIViewController {
  
  @IBOutlet weak var textView: ChordTextView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var customKeyboard: KeyboardView!
  private var segmentedControlItem: UISegmentedControl?
  var keyboard: UIView?
  
  var song: Song?
  var chords: [Chord] = []
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    chords = ChordsManager.shared.getChordsFrom(song: song!)
    initCustomKeyboard()
  }
  private func initCustomKeyboard() {
    customKeyboard.delegate = textView
    customKeyboard.chords = self.chords
    customKeyboard.reloadData()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initToolBarForKeyboard()
    initCircleButton()
    initTextAndScrollViews()
    
    keyboard = textView.inputView
    // Init and set bar button item
    let nextBarItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(SongViewController.nextBarItemAction))
    navigationItem.rightBarButtonItem = nextBarItem
    // Add observers on keyboard event
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
  }
  
  private func initTextAndScrollViews() {
    if song?.textTextView != nil {
    textView.attributedText = song?.textTextView
    }
    textView.layoutIfNeeded()
    let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
    scrollView.contentSize.height = contentSize.height
    if contentSize.width > UIScreen.main.bounds.width {
    scrollView.contentSize.width = contentSize.width
    } else {
      scrollView.contentSize.width = UIScreen.main.bounds.width
    }
    // Other
    textView.delegate = textView
    textView.delegateChordTextView = self
    let gestrueTapScrollView = UITapGestureRecognizer(target: self, action: #selector(SongViewController.chooseEditingView))
    scrollView.addGestureRecognizer(gestrueTapScrollView)
  }
  
  private func initCircleButton() {
    let circleImage = UIImage(named: "circleIcon.png")?.withRenderingMode(.alwaysTemplate)
    let imageView = UIImageView(image: circleImage)
    imageView.tintColor = .background2
    imageView.contentMode = .scaleAspectFit
    let centerButton =  UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    imageView.frame = centerButton.bounds
    centerButton.addSubview(imageView)
    imageView.isUserInteractionEnabled = true
    let gestrueTapCircleButton = UITapGestureRecognizer(target: self, action: #selector(SongViewController.circleButtonAction))
    imageView.addGestureRecognizer(gestrueTapCircleButton)
    self.navigationItem.titleView = centerButton
  }
  
  private func initToolBarForKeyboard() {
    //init toolbar
    let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
    toolbar.barStyle = .blackTranslucent
    toolbar.isTranslucent = false
    toolbar.tintColor = UIColor.white
    toolbar.barTintColor =  UIColor.gray
    //create left side empty space so that done button set on right side
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self,
                                                   action: #selector(SongViewController.doneButtonAction))
    initSegmentedControll()
    let segmentBarItem = UIBarButtonItem(customView: self.segmentedControlItem!)
    toolbar.setItems([segmentBarItem ,flexSpace, doneBtn], animated: false)
    toolbar.sizeToFit()
    //setting toolbar as inputAccessoryView
    self.textView.inputAccessoryView = toolbar
  }
  private func initSegmentedControll() {
    let segmentedItemArray = ["Text", "Chords"]
    self.segmentedControlItem = UISegmentedControl(items: segmentedItemArray)
    self.segmentedControlItem?.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
    self.segmentedControlItem?.selectedSegmentIndex = 0
    self.segmentedControlItem?.addTarget(self, action: #selector(SongViewController.changeSegmentedControll), for: .valueChanged)
  }
  
  @objc func circleButtonAction() {
    let circleVC = storyboard?.instantiateViewController(withIdentifier: "CircleViewController") as? CircleViewController
    guard let song = song else { return }
    circleVC?.song = song
    self.navigationController?.pushViewController(circleVC!, animated: true)
  }
  
  @objc func changeSegmentedControll() {
    if segmentedControlItem?.selectedSegmentIndex == 0 {
      textView.inputView = keyboard
      textView.reloadInputViews()
      textView.becomeFirstResponder()
    } else {
      if chords.count == 0 {
        let circleVC = storyboard?.instantiateViewController(withIdentifier: "CircleViewController") as! CircleViewController
        setSong()
        circleVC.song = song
        navigationController?.pushViewController(circleVC, animated: true)
      }
      textView.inputView = customKeyboard
      textView.reloadInputViews()
      textView.becomeFirstResponder()
    }
  }
  // MARK: - Keyboard event
  @objc func keyboardWillShow(_ notification: Notification) {
    // Get keyboard hight
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
    let keyboardSize = keyboardInfo.cgRectValue.size
    
    // Set insets
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  @objc func keyboardDidHide() {
    // Return old insets
    scrollView.contentInset = .zero
    scrollView.scrollIndicatorInsets = .zero
  }
  
  @objc func nextBarItemAction() {
    let saveSongVC = storyboard?.instantiateViewController(withIdentifier: "SaveSongViewController") as? SaveSongViewController
    setSong()
    saveSongVC?.song = song
    navigationController?.pushViewController(saveSongVC!, animated: true)
  }
  
  @objc func doneButtonAction() {
    self.view.endEditing(true)
  }
  
  @objc func chooseEditingView() {
    textView.becomeFirstResponder()
  }
  
  private func setSong() {
    let chords = self.chords.map { $0.chordStruct.name }
    song?.chords = chords
    song?.textTextView = textView.attributedText
    song?.widthTextView = Float(textView.frame.width)
  }
  
  override func viewWillDisappear(_ animated : Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParentViewController {
      if song?.date == nil {
        CoreDataManager.shared.delete(song: song!)
      }
    }
  }
  
}

extension SongViewController: ChordTextViewDelegate {
  
  func clickOn(chord: Chord) {}
  
  func textViewDidChange() {
    if textView.contentSize.height > UIScreen.main.bounds.height {
    scrollView.contentSize.height = textView.contentSize.height
    } else {
      scrollView.contentSize.height = UIScreen.main.bounds.height
    }
    if textView.contentSize.width > UIScreen.main.bounds.width {
      scrollView.contentSize.width = textView.contentSize.width
    } else {
      scrollView.contentSize.width = UIScreen.main.bounds.width
    }
  }
}

extension SongViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chords.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeyChordTableViewCell")
      as? KeyChordTableViewCell else { return UITableViewCell() }
    cell.chord = chords[indexPath.row]
    return cell
  }
}

class textView: UITextView {
  var _inputViewController : UIInputViewController?
  override public var inputViewController: UIInputViewController?{
    get { return _inputViewController }
    set { _inputViewController = newValue }
  }
}
