//
//  QRScannerCaptionProvider.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 16.06.2022.
//

import AVFoundation

protocol QRScannerCaptionProvider {
    var delegate: CaptureProviderDelegate? { get set }
    var captureSession: AVCaptureSession { get }
    
    func configure()
    func startCaption()
    func stopCaption()
}
