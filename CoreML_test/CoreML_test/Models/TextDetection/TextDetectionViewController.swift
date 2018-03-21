//
//  TextDetectionViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 20.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import TesseractOCR

class TextDetectionViewController: UIViewController {

    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var datectedTextLabel: UILabel!
    
    var session = AVCaptureSession()
    var request = [VNRequest]()
   //  private var tesseract = G8Te
    
    var presenter: TextDetectionPresenter!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLiveVideo()
        startTextDetection()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        startLiveVideo()
//        startTextDetection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        cameraImageView.layer.sublayers?[0].frame = cameraImageView.bounds
    }
    
    func startLiveVideo(){
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = cameraImageView.bounds
        cameraImageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
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
            self.cameraImageView.layer.sublayers?.removeSubrange(1...)
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
        
        let xCord = maxX * cameraImageView.frame.size.width
        let yCord = (1 - minY) * cameraImageView.frame.size.height
        let width = (minX - maxX) * cameraImageView.frame.size.width
        let height =  (minY - maxY) * cameraImageView.frame.size.width
        
        let outline = CALayer()
        
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        
        cameraImageView.layer.addSublayer(outline)
                
    }
    
    
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * cameraImageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * cameraImageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * cameraImageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * cameraImageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        cameraImageView.layer.addSublayer(outline)
    }
    
    
}

extension TextDetectionViewController: TextDetectionView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.request)
        } catch {
            print(error)
        }
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//
//        var requestOptions: [VNImageOption: Any] = [:]
//        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
//        }
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 1)!, options: requestOptions)
//        do {
//            try imageRequestHandler.perform(request)
//        } catch {
//            print(error)
//        }
//    }
    
}
