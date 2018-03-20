//
//  MainViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML
import CoreVideo

class MainViewController: UIViewController {

	var presenter: MainPresenter!

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var resultOfVideoLabel: UILabel!
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let captureQueue = DispatchQueue(label: "captureQueue")
    var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupCamera()
        
    }
    
    @IBAction func openTextRecognitionView(_ sender: Any) {
        presenter.navigateToTextDetectorView()
    }
    
    override func viewDidLayoutSubviews() {
       // super.viewDidLayoutSubviews()
        //previewLayer.frame = view.frame
    }
    
    func setupCamera(){
        guard let camera = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoView.layer.addSublayer(previewLayer)
            
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            session.sessionPreset = .high
            session.addInput(cameraInput)
            session.addOutput(videoOutput)
            
            let connection = videoOutput.connection(with: .video)
            connection?.videoOrientation = .portrait
            session.startRunning()
            
            guard let visionModel = try? VNCoreMLModel(for: Inceptionv3().model) else {
                fatalError("Could not load model")
            }
            
            let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleClassifications)
            classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
            visionRequests = [classificationRequest]
        } catch {
            let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func handleClassifications(request: VNRequest, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let results = request.results as? [VNClassificationObservation] else {
            print("No results")
            return
        }
        
        var resultString = "This is not a dog!"
        results[0...3].forEach {
            let identifer = $0.identifier.lowercased()
            if identifer.range(of: " dog") != nil || identifer.range(of: "dog ") != nil || identifer == "dog" {
                resultString = "This is a \(identifer)"
            }
            //resultString = "This is a \(identifer)"
        }
        DispatchQueue.main.async {
            self.resultOfVideoLabel?.text = resultString
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension MainViewController: MainView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions: [VNImageOption: Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 1)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print(error)
        }
    }
}
