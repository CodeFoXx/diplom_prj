//
//  TranslationViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import Foundation

let EN_RU = "en-ru"
let RU_EN = "ru-en"

class TranslationViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet var swipe: UISwipeGestureRecognizer!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var yandexRequirmentTextView: UITextView!
    @IBOutlet weak var sourceLangButton: UIButton!
    @IBOutlet weak var translatedLangButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var sourceTextPlaceholder: UILabel!
    var translatedTextPlaceholder: UILabel!
    var languageDict: Bool!
    var swipeGesture = UISwipeGestureRecognizer()
    
    
    var presenter: TranslationPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageDict = true
        setPlaceholder()
        setButtonImage()
        setSwipe()
    }
    
    func setButtonImage(){
        cameraButton.setImage(#imageLiteral(resourceName: "camera_white"), for: .normal)
        cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .highlighted)
        copyButton.setImage(#imageLiteral(resourceName: "copy_white"), for: .normal)
        copyButton.setImage(#imageLiteral(resourceName: "copy"), for: .highlighted)
        shareButton.setImage(#imageLiteral(resourceName: "share_white"), for: .normal)
        shareButton.setImage(#imageLiteral(resourceName: "share"), for: .highlighted)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setSwipe(){
        let direction: UISwipeGestureRecognizerDirection = .left
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(TranslationViewController.handleSwipes(_:)))
        view.addGestureRecognizer(swipeGesture)
        swipeGesture.direction = direction
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            if sender.direction == .left{
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.sourceTextView.text = ""
                self.translatedTextView.text = ""
                self.sourceTextPlaceholder.isHidden = false
                self.translatedTextPlaceholder.isHidden = false
                
            }
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
        
    }
    
    func setPlaceholder(){
        self.sourceTextView.delegate = self
        self.translatedTextView.delegate = self
        
        //source text placeholder
        sourceTextPlaceholder = UILabel()
        sourceTextPlaceholder.text = "Enter text to translate..."
        sourceTextPlaceholder.font = UIFont (name: "HelveticaNeue-Light", size: 17)
        sourceTextPlaceholder.sizeToFit()
        sourceTextView.addSubview(sourceTextPlaceholder)
        sourceTextPlaceholder.frame.origin = CGPoint(x: 5, y: (sourceTextView.font?.pointSize)! / 2)
        sourceTextPlaceholder.textColor = #colorLiteral(red: 0.6644862532, green: 0.6774402177, blue: 0.73074694, alpha: 1)
        sourceTextPlaceholder.isHidden = !sourceTextView.text.isEmpty
        
        //source text placeholder
        translatedTextPlaceholder = UILabel()
        translatedTextPlaceholder.text = "Translated text"
        translatedTextPlaceholder.font = UIFont (name: "HelveticaNeue-Light", size: 17)
        translatedTextPlaceholder.sizeToFit()
        translatedTextView.addSubview(translatedTextPlaceholder)
        translatedTextPlaceholder.frame.origin = CGPoint(x: 5, y: (translatedTextView.font?.pointSize)! / 2)
        translatedTextPlaceholder.textColor = #colorLiteral(red: 0.6644862532, green: 0.6774402177, blue: 0.73074694, alpha: 1)
        translatedTextPlaceholder.isHidden = !translatedTextView.text.isEmpty
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sourceTextPlaceholder.isHidden = !sourceTextView.text.isEmpty
        translatedTextPlaceholder.isHidden = !translatedTextView.text.isEmpty
    }
    
    
    @IBAction func languageReplacer(_ sender: Any) {
        let tmp = sourceLangButton.currentTitle
        sourceLangButton.setTitle(translatedLangButton.currentTitle, for: [])
        translatedLangButton.setTitle(tmp, for: [])
        languageDict = !languageDict
        
    }
    
    @IBAction func translationLanguageChanger(_ sender: Any) {
    }
    
    @IBAction func sourceLanguageChanger(_ sender: Any) {
    }
    
    @IBAction func shareButton(_ sender: Any) {
        var item = sourceTextView.text
        item = item?.appending(" - \(translatedTextView.text!)")
        let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = translatedTextView.text
    }
    
    
    
    @IBAction func imagePickerButton(_ sender: Any) {
        presenter.navigateToTextDetectionView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sourceTextView.resignFirstResponder()
        translatedTextView.resignFirstResponder()
    }
    
        
}

extension TranslationViewController: TranslationView {
        
    func setTranslatedText(text: [String]) {
        translatedTextPlaceholder.isHidden = true
        translatedTextView.text = String(text.flatMap{ String($0)})
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            sourceTextView.resignFirstResponder()
            if languageDict == true{
                presenter.translationRequest(language: RU_EN, text: sourceTextView.text)
            }
            else{
                presenter.translationRequest(language: EN_RU, text: sourceTextView.text)
            }
            return false
        }
        return true
    }
    
}

