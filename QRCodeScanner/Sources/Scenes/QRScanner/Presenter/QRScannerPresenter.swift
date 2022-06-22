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
    func handleUrl(url: URL) {
        print(url)
        view?.showWebView(with: url)
    }
    
    func handleResultMessage(result: CaptureProvider.CameraConfiguration) {
        switch result {
        case .denied:
            view?.showAlert(openSettings: true, message: NSLocalizedString("NOT_AUTHORIZED_MESSAGE", comment: ""))
        default:
            view?.showAlert(openSettings: false, message: NSLocalizedString("CONFIGURATION_FAILURE_MESSAGE", comment: ""))
        }
    }
}
