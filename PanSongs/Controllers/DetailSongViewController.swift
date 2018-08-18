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
        chordView.initGesture()
        let width: CGFloat = 130
        let height: CGFloat = 200
        let x = UIScreen.main.bounds.width / 2 - width / 2
        let y = UIScreen.main.bounds.height - height
        chordView.frame = CGRect(x: x, y: y, width: width, height: height)
        setFrameAndContentSize()
    }
    private func setFrameAndContentSize(){
            textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
            scrollView.contentSize.height = textView.frame.size.height
            scrollView.contentSize.width = textView.frame.size.width
    }
    private func initTextView() {
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegatChordTextView = self
        textView.delegate = textView
        textView.attributedText = song?.textTextView
    }
    private func initEditButton () {
        let imageView = UIImageView(image: UIImage(named: "editIcon.png"))
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
extension DetailSongViewController: ChordTextViewDelegat {
    func textViewDidChange() {
        textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: textView.contentSize.height))
        scrollView.contentSize.height = textView.frame.size.height
        scrollView.contentSize.width = textView.frame.size.width
    }
    
    func clickOnChord(chord: Chord) {
        chordView.setChord(chord: chord)
        chordView.isHidden = false
    }
}
