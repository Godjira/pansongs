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
    let chordManager = ChordsManager.shared()
    
    var saveSongVC: SaveSongViewController?
    var circleVC: CircleViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        if song != nil {
            textView.attributedText = song?.textTextView
            textView.frame = CGRect(x: textView.frame.origin.x,
                                    y: textView.frame.origin.y,
                                    width: CGFloat(song!.widthTextView),
                                    height: textView.frame.height)
            scrollView.contentSize.width = CGFloat(song!.widthTextView)
        }
        keyboard = textView.inputView
        // Init and set bar button item
        let nextBarItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(SongViewController.nextBarItemAction))
        navigationItem.rightBarButtonItem = nextBarItem
        // Add observers on keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
        
        textView.delegate = textView
        textView.delegatChordTextView = self
        let gestrueTapScrollView = UITapGestureRecognizer(target: self, action: #selector(SongViewController.chooseEditingView))
        scrollView.addGestureRecognizer(gestrueTapScrollView)
    }
    private func initCircleButton() {
        let imageView = UIImageView(image: UIImage(named: "circleIcon.png"))
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
        if circleVC == nil {
            circleVC = storyboard?.instantiateViewController(withIdentifier: "CircleViewController") as? CircleViewController
        }
        circleVC?.songVC = self
        circleVC?.chords = chords
        self.navigationController?.pushViewController(circleVC!, animated: true)
    }
    // MARK: - Keyboard event
    @objc func keyboardWillShow(_ notification: Notification) {
        // Get keyboard hight
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        // Set inset
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
        if saveSongVC == nil {
            saveSongVC = storyboard?.instantiateViewController(withIdentifier: "SaveSongViewController") as? SaveSongViewController
            if song != nil {
                song?.textTextView = textView.attributedText
                song?.widthTextView = Float(textView.frame.width)
                saveSongVC!.song = song
            }
        }
        saveSongVC?.widthTextView = Float(textView.frame.width)
        saveSongVC?.chordSongTextViewString = textView.attributedText
        navigationController?.pushViewController(saveSongVC!, animated: true)
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @objc func chooseEditingView() {
        textView.becomeFirstResponder()
    }
    
    @objc func changeSegmentedControll() {
        if segmentedControlItem?.selectedSegmentIndex == 0 {
            textView.inputView = keyboard
            textView.reloadInputViews()
            textView.becomeFirstResponder()
        } else {
            if chords.count == 0 {
                if circleVC == nil {
                    circleVC = storyboard?.instantiateViewController(withIdentifier: "CircleViewController") as! CircleViewController
                }
                circleVC?.songVC = self
                navigationController?.pushViewController(circleVC!, animated: true)
            }
            textView.inputView = customKeyboard
            textView.reloadInputViews()
            textView.becomeFirstResponder()
        }
    }
    
}


extension SongViewController: ChordTextViewDelegat {
    
    func clickOnChord(chord: Chord) {
        
    }
    func textViewDidChange() {
            textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
            scrollView.contentSize.height = textView.frame.size.height
            scrollView.contentSize.width = textView.frame.size.width
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
