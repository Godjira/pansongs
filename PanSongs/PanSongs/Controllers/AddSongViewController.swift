//
//  ViewController.swift
//  PanSongs
//
//  Created by Homac on 7/10/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

class AddSongViewController: UIViewController {

    @IBOutlet weak var chordsTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    var frontTextView = true
    var segmentedControlItem: UISegmentedControl?

    @IBOutlet weak var editingSegmented: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!

    var chords: [Chord] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initToolBarForKeyboard()

        scrollView.bringSubview(toFront: textView)
        chordsTextView.textColor = UIColor.orange
        textView.delegate = self

        let gestrueTapScrollView = UITapGestureRecognizer(target: self, action: #selector(AddSongViewController.chooseEditingView))
        scrollView.addGestureRecognizer(gestrueTapScrollView)

        if textView.frame.height < scrollView.frame.height {
            textView.frame = CGRect(origin: textView.frame.origin,
                                    size: CGSize(width: textView.frame.width,
                                                 height: scrollView.frame.height))
        }
    }

    func initToolBarForKeyboard() {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        toolbar.barStyle = .blackTranslucent
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor =  UIColor.gray
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self,
                                                       action: #selector(AddSongViewController.doneButtonAction))

        let segmentedItemArray = ["Text", "Chords"]
        self.segmentedControlItem = UISegmentedControl(items: segmentedItemArray)
        self.segmentedControlItem?.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        self.segmentedControlItem?.selectedSegmentIndex = 0
        let segmentBarItem = UIBarButtonItem(customView: self.segmentedControlItem!)


        self.segmentedControlItem?.addTarget(self, action: #selector(AddSongViewController.changeSegmentedControll), for: .valueChanged)

        toolbar.setItems([segmentBarItem ,flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()

        //setting toolbar as inputAccessoryView
        self.chordsTextView.inputAccessoryView = toolbar
        self.textView.inputAccessoryView = toolbar
    }

    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

    @objc func chooseEditingView() {
        if segmentedControlItem?.selectedSegmentIndex == 0 {
            chordsTextView.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = true
            textView.becomeFirstResponder()
        } else {
            textView.isUserInteractionEnabled = false
            chordsTextView.isUserInteractionEnabled = true
            chordsTextView.becomeFirstResponder()
        }
    }

     @objc func changeSegmentedControll() {
        if segmentedControlItem?.selectedSegmentIndex == 0 {
            scrollView.bringSubview(toFront: textView)
            chordsTextView.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = true
            textView.becomeFirstResponder()
        } else {
            scrollView.bringSubview(toFront: chordsTextView)
            textView.isUserInteractionEnabled = false
            chordsTextView.isUserInteractionEnabled = true
            chordsTextView.becomeFirstResponder()

        }
    }
}


extension AddSongViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            //textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
            scrollView.contentSize.height = textView.frame.size.height
            scrollView.contentSize.width = textView.frame.size.width
        }
    }
    
}

