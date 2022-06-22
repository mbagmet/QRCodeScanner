//
//  CaptureProvider.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 15.06.2022.
//

import AVFoundation

class CaptureProvider: NSObject, QRScannerCaptionProvider {
    
    // MARK: - Properties
    
    weak var delegate: CaptureProviderDelegate?
    
    // Session
    let captureSession = AVCaptureSession()
    private let captureQueue = DispatchQueue(label: "Capture Queue")
    
    // Camera configuration
    private enum CameraConfiguration {
        case success
        case denied
        case failed
    }
    private var cameraConfiguration: CameraConfiguration = .success
    
    // Video Input, Metadata Output
    private var videoDeviceInput: AVCaptureDeviceInput!
    private let metadataOutput = AVCaptureMetadataOutput()
    private let metadataObjectsQueue = DispatchQueue(label: "Metadata Objects Queue")
    private let metadataObjectsSemaphore = DispatchSemaphore(value: 1)
    
    // MARK: - Configuration
    
    func configure() {
        checkCameraAccess()
        
        captureQueue.async {
            self.configureSession()
        }
    }
    
    // MARK: - Start / Stop capture session
    
    /// Если конфигурация камеры .success,  то начинает захват видео
    func startCaption() {
        captureQueue.async {
            switch self.cameraConfiguration {
                
            case .success:
                self.captureSession.startRunning()
            case .denied:
                DispatchQueue.main.async {
                    self.delegate?.handleResultMessage(openSettings: true, message: NSLocalizedString("NOT_AUTHORIZED_MESSAGE", comment: ""))
                }
            case .failed:
                DispatchQueue.main.async {
                    self.delegate?.handleResultMessage(openSettings: false, message: NSLocalizedString("CONFIGURATION_FAILURE_MESSAGE", comment: ""))
                }
            }
        }
    }
    
    /// Останавливает захват видео
    func stopCaption() {
        captureQueue.async {
            if self.cameraConfiguration == .success {
                self.captureSession.stopRunning()
            }
        }
    }

    // MARK: - Private Functions
    
    // MARK: Check Camera Access
    /// Выводит запрос на использование камеры для видео
    private func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            break
            
        case .notDetermined:
            captureQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.cameraConfiguration = .denied
                }
                self.captureQueue.resume()
            }

        default:
            cameraConfiguration = .denied
        }
    }
    
    // MARK: Session Configuration
    private func configureSession() {
        if cameraConfiguration != .success {
            return
        }
        
        captureSession.beginConfiguration()
        addVideoInput()
        addMetadataOutput()
        captureSession.commitConfiguration()
    }
    
    // MARK: Video input
    /// Если получил в свое распоряжение камеру, то добавляет Input в captureSession
    private func addVideoInput() {
        do {
            guard let videoDevice = getVideoDevice() else {
                cameraConfiguration = .failed
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                cameraConfiguration = .failed
                captureSession.commitConfiguration()
                return
            }
            
        } catch {
            print("Could not create video device input: \(error)")
            cameraConfiguration = .failed
            captureSession.commitConfiguration()
            return
        }
    }
    
    /// Helper for addVideoInput()
    /// Последовательно пытается достучаться к доступному модулю камеры. Сначала к задней, потом — фронтальной. Если не смог, то nil
    /// - Returns: Доступный модуль камеры
    private func getVideoDevice() -> AVCaptureDevice? {
        let defaultVideoDevice: AVCaptureDevice?
        
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            defaultVideoDevice = backCamera
        } else if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            defaultVideoDevice = frontCamera
        } else {
            defaultVideoDevice = nil
        }
        
        return defaultVideoDevice
    }
    
    // MARK: Metadata Output
    /// Если есть возможность, то создаем вывод метаданных типа qr-код
    private func addMetadataOutput() {
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: metadataObjectsQueue)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CaptureProvider: AVCaptureMetadataOutputObjectsDelegate {
    
    /// При нахождении мета-данных проверяем, что это QR-код и в нем закодирована ссылка. Если да, то запускаем openWebView(with: qrCodeText)
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            return
        }
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadataObject.type == AVMetadataObject.ObjectType.qr {
            guard let qrCodeText = metadataObject.stringValue else { return }

            if !qrCodeText.isValidURL{
                return
            }
            
            if let url = URL(string: qrCodeText) {
                if metadataObjectsSemaphore.wait(timeout: .now() + 0.1) == .success {
                    DispatchQueue.main.async {
                        self.delegate?.handleUrl(url: url)
                        self.stopCaption()
                        self.metadataObjectsSemaphore.signal()
                    }          
                }
            }
        }
    }
}
