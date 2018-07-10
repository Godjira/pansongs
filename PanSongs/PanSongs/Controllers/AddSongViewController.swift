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
    var frontText = true

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bringSubview(toFront: textView)
        chordsTextView.textColor = UIColor.orange
        textView.delegate = self


        initToolBarForKeyboard()
        if textView.frame.height < scrollView.frame.height {
            textView.frame = CGRect(origin: textView.frame.origin,
                                    size: CGSize(width: textView.frame.width,
                                                 height: scrollView.frame.height))
        }
    }

    func initToolBarForKeyboard() {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))

        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self,
                                                       action: #selector(AddSongViewController.doneButtonAction))

        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()

        //setting toolbar as inputAccessoryView
        self.chordsTextView.inputAccessoryView = toolbar
        self.textView.inputAccessoryView = toolbar
    }

    @objc func doneButtonAction() {
        self.view.endEditing(true)

    }


    @IBAction func textOrChordsAction(_ sender: UIButton) {
        if frontText {
            scrollView.bringSubview(toFront: chordsTextView)
            frontText = false
        } else {
            scrollView.bringSubview(toFront: textView)
            frontText = true
        }
    }
}

extension AddSongViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            //textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
            scrollView.contentSize.height = textView.frame.size.height
        }

        if textView.frame.height < scrollView.frame.height {
            textView.frame = CGRect(origin: textView.frame.origin,
                                    size: CGSize(width: textView.frame.width,
                                                 height: scrollView.frame.height))
        }
    }
    
}

