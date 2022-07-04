//
//  QRScanner.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import AVFoundation

protocol QRScanner {
    var view: QRScannerPresenterDelegate? { get set }
    var captureSession: AVCaptureSession? { get set }
    
    func setViewDelegate(delegate: QRScannerPresenterDelegate)
    func configureCaptureService()
    
    func startCaptureService()
    func stopCaptureService()
}
