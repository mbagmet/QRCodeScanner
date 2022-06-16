//
//  CameraPreviewView.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 16.06.2022.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    // MARK: - Properties
    
    // Caption session
    var captureSession: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // Preview layer
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected AVCaptureVideoPreviewLayer type for layer.")
        }
        
        return layer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
