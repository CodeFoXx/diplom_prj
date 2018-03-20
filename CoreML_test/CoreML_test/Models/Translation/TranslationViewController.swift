//
//  TranslationViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

import UIKit

class TranslationViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    
    var sourceTextPlaceholder: UILabel!
    var translatedTextPlaceholder: UILabel!
    
    
    
    var presenter: TranslationPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlaceholder()
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
    }
    
    @IBAction func translationLanguageChanger(_ sender: Any) {
    }
    
    @IBAction func sourceLanguageChanger(_ sender: Any) {
    }
    
    @IBAction func shareButton(_ sender: Any) {
    }
    
    @IBAction func copyButton(_ sender: Any) {
        translatedTextPlaceholder.isHidden = true
        translatedTextView.text = "blabla"
    }
    
    @IBAction func translateButton(_ sender: Any) {
        presenter.translationRequest(language: "en-ru", text: sourceTextView.text)
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sourceTextView.resignFirstResponder()
        translatedTextView.resignFirstResponder()
    }
}

extension TranslationViewController: TranslationView {
    
}
