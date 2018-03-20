//
//  PreviewView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer{
        guard let layer = layer as? AVCaptureVideoPreviewLayer else{
            fatalError("Expected 'AVCaptureVideoPreviewLayer' type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
    var session: AVCaptureSession?{
        get {
            return videoPreviewLayer.session
        }
        set{
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }

}
