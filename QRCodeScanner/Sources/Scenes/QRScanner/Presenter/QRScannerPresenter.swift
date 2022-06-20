//
//  QRScannerPresenter.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import AVFoundation

class QRScannerPresenter: QRScanner {
    
    // MARK: - Properties
    
    weak var view: QRScannerPresenterDelegate?
    
    private var captureProvider = CaptureProvider()
    var captureSession: AVCaptureSession?
    
    // MARK: - Initializers
    
    init() {
        captureProvider.delegate = self
    }
    
    // MARK: - Configuration
    
    func setViewDelegate(delegate: QRScannerPresenterDelegate) {
        self.view = delegate
    }
    
    func configureCaptureService() {
        captureProvider.configure()
        captureSession = captureProvider.captureSession
    }
    
    // MARK: - Methods
    
    func startCaptureService() {
        captureProvider.startCaption()
    }
    
    func stopCaptureService() {
        captureProvider.stopCaption()
    }    
}

// MARK: - CaptureProviderDelegate

extension QRScannerPresenter: CaptureProviderDelegate {
    func openWebView(with url: URL) {
        print(url)
        view?.showWebView(with: url)
    }
    
    func openAlert(openSettings: Bool, message: String) {
        view?.showAlert(openSettings: openSettings, message: message)
    }
}
