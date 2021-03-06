//
//  OCRViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import CoreML
import Vision

class OCRViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detectedText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
	var presenter: OCRPresenter!
    var model: VNCoreMLModel!
    var request = [VNRequest]()

    
    var textMetadata = [Int: [Int: String]]()
    

	override func viewDidLoad() {
        super.viewDidLoad()
        loadModel()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func loadModel(){
        model = try? VNCoreMLModel(for: Alphanum_28x28().model)
    }
    
    @IBAction func pickImageClicked(_ sender: UIButton){
        let alertController = createActionSheet()
        let action1 = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showImagePicker(withType: .camera)
        })
        let action2 = UIAlertAction(title: "Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showImagePicker(withType: .photoLibrary)

            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addActionsToAlertController(controller: alertController,
                                    actions: [action1, action2, cancelAction])
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showImagePicker(withType type: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        present(pickerController, animated: true, completion: nil)
    }
    
    func detectText(image: UIImage){
        let convertedImage = image |> adjustColors |> convertToGrayscale
        let handler = VNImageRequestHandler(cgImage: convertedImage.cgImage!)
        let request: VNDetectTextRectanglesRequest =
            VNDetectTextRectanglesRequest(completionHandler: {
                [unowned self] (request, error) in
                if (error != nil){
                    print("Got Error in run text detect request")
                } else{
                    guard let results = request.results as? Array<VNTextObservation> else {
                        fatalError("Unexpected result type from VNDetectTextRectanglesRequest")
                    }
                    if (results.count == 0) {
                        self.handleEmptyResults()
                        return
                    }
                    var numberOfWords = 0
                    for textObsevation in results {
                        var numberOfCharacters = 0
                        for rectangleObservation in textObsevation.characterBoxes! {
                            let croppedImage = crop(image: image, rectangle: rectangleObservation)
                            if let croppedImage = croppedImage {
                                let processedImage = preProcess(image: croppedImage)
                                self.classifyImage(image: processedImage,
                                                   wordNumber: numberOfWords, characterNumber: numberOfCharacters)
                                numberOfCharacters += 1
                            }
                        }
                        numberOfWords += 1
                    }
                }
            })
        request.reportCharacterBoxes = true
        do {
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
    func handleEmptyResults() {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            self.detectedText.text = "The image does not contain any text"
        }
    }
    
    func classifyImage(image: UIImage, wordNumber: Int, characterNumber: Int){
        let request = VNCoreMLRequest(model: model) {
            [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type from VNCoreMLRequest")
            }
            let result = topResult.identifier
            let classificationInfo: [String: Any] = ["wordNumber" : wordNumber,
                                                     "characterNumber" : characterNumber,
                                                     "class" : result]
            self?.handleResult(classificationInfo)
        }
        guard let ciImage = CIImage(image: image) else{
            fatalError("Could not convert UIImage to CIImage :(")
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            }
            catch{
                print(error)
            }
        }
    }
    
    
    func handleResult(_ result: [String: Any]) {
        objc_sync_enter(self)
        guard let wordNumber = result["wordNumber"] as? Int else {
            return
        }
        guard let characterNumber = result["characterNumber"] as? Int else {
            return
        }
        guard let characterClass = result["class"] as? String else {
            return
        }
        if (textMetadata[wordNumber] == nil){
            let tmp: [Int: String] = [characterNumber: characterClass]
            textMetadata[wordNumber] = tmp
        } else{
            var tmp = textMetadata[wordNumber]!
            tmp[characterNumber] = characterClass
            textMetadata[wordNumber] = tmp
        }
        objc_sync_exit(self)
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            self.showDetectedText()
        }
    }
    
    func showDetectedText(){
        var result: String = ""
        if (textMetadata.isEmpty) {
            detectedText.text = "The image does not contain any text."
            return
        }
        let sortedKeys = textMetadata.keys.sorted()
        for sortedKey in sortedKeys {
            result += word(fromDictionary: textMetadata[sortedKey]!) + " "
        }
        detectedText.text = result
    }
    
    func word(fromDictionary dictionary: [Int : String]) -> String{
        let sortedKeys = dictionary.keys.sorted()
        var word: String = ""
        for sortedKey in sortedKeys{
            let char: String = dictionary[sortedKey]!
            word += char
        }
        return word
    }
    
    private func clearOldData(){
        detectedText.text = ""
        textMetadata = [:]
    }
    
    private func showActivityIndicator(){
        activityIndicator.startAnimating()
    }

    private func hideActivityIndicator(){
        activityIndicator.stopAnimating()
    }
    
    
    
    // text detection
    
    func startTextDetection(){
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.request = [textRequest]
    }
    
    func detectTextHandler(request: VNRequest, error: Error?){
        
        guard let observation = request.results else {
            print("no result")
            return
        }
        
        let result = observation.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            self.imageView.layer.sublayers?.removeSubrange(1...)
            for region in result {
                guard let rg = region else {
                    continue
                }
                
                self.highlightWord(box: rg)
                
                if let boxes = region?.characterBoxes{
                    for characterBox in boxes{
                        self.highlightLetters(box: characterBox)
                    }
                }
                
            }
        }
    }
    
    func highlightWord(box: VNTextObservation){
        guard let boxes = box.characterBoxes else {
            return
        }
        
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        
        for char in boxes {
            if char.bottomLeft.x < maxX{
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY{
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let xCord = maxX * imageView.frame.size.width
        let yCord = (1 - minY) * imageView.frame.size.height
        let width = (minX - maxX) * imageView.frame.size.width
        let height =  (minY - maxY) * imageView.frame.size.width
        
        let outline = CALayer()
        
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        
        imageView.layer.addSublayer(outline)
        
    }
    
    
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * imageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        imageView.layer.addSublayer(outline)
    }
    
    
}

extension OCRViewController: OCRView {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        guard let image = info[UIImagePickerControllerOriginalImage] else {
            fatalError("Couldn't load image")
        }
        let newImage = fixOrientation(image: image as! UIImage)
        self.imageView.image = newImage
        clearOldData()
        showActivityIndicator()
        DispatchQueue.global(qos: .userInteractive).async {
            self.detectText(image: newImage)
            self.startTextDetection()
        }
        
    }
    
}


