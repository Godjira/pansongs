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

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bringSubview(toFront: chordsTextView)
        chordsTextView.textColor = UIColor.orange
        textView.delegate = self


        

    }



    @IBAction func textOrChordsAction(_ sender: UIButton) {
        
    }
}

extension AddSongViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            scrollView.contentSize.height = textView.frame.size.height
        }
    }
    
}

