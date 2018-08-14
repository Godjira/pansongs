//
//  ViewController.swift
//  PanSongs
//
//  Created by Homac on 7/10/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

class AddSongViewController: UIViewController {
    
    @IBOutlet weak var chordsTextView: ChordTextView!
    @IBOutlet weak var textView: UITextView!
    
    private var frontTextView = true
    private var segmentedControlItem: UISegmentedControl?
    
    @IBOutlet var keyboardView: KeyboardView!
    @IBOutlet weak var editingSegmented: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var prevScrollViewHight: CGFloat = 0.0
    
    @IBOutlet weak var scrollViewHightConstraint: NSLayoutConstraint!
    
    var chords: [Chord] = []
    
    var saveSongVC: SaveSongViewController?
    
    @IBOutlet weak var keyChordBoardTableView: UITableView!
    
    private var stringForChordTV: String?
    private var stringForTextTV: String?
    private var needCustomStringTextViews: Bool = false
    
    let chordManager = ChordsManager.shared()
    
    var lastPositionTouch = CGPoint(x: 0, y: 0)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initCustomKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initToolBarForKeyboard()
        // Init and set bar button item
        let barItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(AddSongViewController.doneBarItemAction))
        navigationItem.rightBarButtonItem = barItem
        // Add observers on keyboard event
        prevScrollViewHight = scrollViewHightConstraint.constant
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
        
        scrollView.bringSubview(toFront: textView)
        textView.delegate = self
        chordsTextView.delegate = chordsTextView
        chordsTextView.delegatChordTextView = self
                
        let gestrueTapScrollView = UITapGestureRecognizer(target: self, action: #selector(AddSongViewController.chooseEditingView))
        scrollView.addGestureRecognizer(gestrueTapScrollView)
        // Correct hight textView
        if textView.frame.height < scrollView.frame.height {
            textView.frame = CGRect(origin: textView.frame.origin,
                                    size: CGSize(width: textView.frame.width,
                                                 height: scrollView.frame.height))
        }
        setCustomStringTextView()
    }
    
  

    @IBAction func buttAct(_ sender: Any) {
        chordsTextView.isSelectable = true
        chordsTextView.isEditable = false
    }
    
    
    public func setTextViews(textViewWith chord: String, text: String) {
        stringForChordTV = chord
        stringForTextTV = text
        needCustomStringTextViews = true
    }
    private func setCustomStringTextView() {
        if needCustomStringTextViews {
            textView.text = stringForTextTV
            chordsTextView.text = stringForChordTV
        }
    }
    
    @objc func doneBarItemAction() {
        if saveSongVC == nil {
            saveSongVC = storyboard?.instantiateViewController(withIdentifier: "SaveSongViewController") as? SaveSongViewController
        }
        saveSongVC?.chordSongTextViewString = chordsTextView.text
        saveSongVC?.textSongTextViewString = textView.text
        navigationController?.pushViewController(saveSongVC!, animated: true)
    }
    
    private func initCustomKeyboard() {
        keyboardView.delegate = chordsTextView
        keyboardView.chords = self.chords
        keyboardView.reloadData()
        chordsTextView.inputView = keyboardView
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let location = touch!.location(in: view)
        lastPositionTouch = location
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

extension AddSongViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension AddSongViewController: ChordTextViewDelegat {
    func clickOnChord(chord: Chord) {
        print(chord.chordStruct.name)
//        let chordLabel = UITextView(frame: CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 150, height: 200)))
//        chordLabel.text = chord.getCurrentChordString().first
//        chordLabel.backgroundColor = UIColor.white
//        view.addSubview(chordLabel)
    }
}

class chordsTextView: UITextView {
    var _inputViewController : UIInputViewController?
    override public var inputViewController: UIInputViewController?{
        get { return _inputViewController }
        set { _inputViewController = newValue }
    }
}
