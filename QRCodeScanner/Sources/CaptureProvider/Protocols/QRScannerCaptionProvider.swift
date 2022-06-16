//
//  QRScannerCaptionProvider.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 16.06.2022.
//

import AVFoundation

protocol QRScannerCaptionProvider {
    var captureSession: AVCaptureSession { get }
    
    func configure()
    
}
