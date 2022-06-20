//
//  QRScannerViewController.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import UIKit
import SnapKit

class QRScannerViewController: UIViewController {

    // MARK: - Properties
    
    var presenter = QRScannerPresenter()
    
    // MARK: - Views
    
    private lazy var cameraPreviewView = CameraPreviewView()
    
    lazy var regionOfInterestImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "caption")

        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Presenter setup
        presenter.setViewDelegate(delegate: self)
        presenter.configureCaptureService()
        
        // MARK: View Setup
        setupHierarchy()
        setupLayout()
        setupView()
        
        // MARK: Camera Preview Setup
        setupCameraPreviewView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.startCaptureService()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.stopCaptureService()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(cameraPreviewView)
        view.addSubview(regionOfInterestImageView)
    }
    
    private func setupLayout() {
        cameraPreviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        regionOfInterestImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
            make.height.equalTo(Metrics.imageSize)
            make.width.equalTo(regionOfInterestImageView.snp.height)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupCameraPreviewView() {
        cameraPreviewView.captureSession = presenter.captureSession
    }
}

// MARK: - Presenter Delegate

extension QRScannerViewController: QRScannerPresenterDelegate {
    func showWebView(with url: URL) {
        let scanResultsViewController = ScanResultsViewController()
        scanResultsViewController.presenter.url = url
        navigationController?.pushViewController(scanResultsViewController, animated: true)
    }
}

// MARK: - Constatnts

extension QRScannerViewController {
    enum Metrics {
        static let imageSize: CGFloat = 200
    }
}
