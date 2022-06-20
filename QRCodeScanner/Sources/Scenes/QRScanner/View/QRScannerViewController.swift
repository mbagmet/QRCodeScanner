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
    
    private lazy var qrLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .white
        
        return label
    }()
    
    lazy var regionOfInterestImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.tintColor = .secondarySystemBackground
        imageView.image = UIImage(named: "caption")
        
//        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = Metric.imageSize / 2
//        imageView.layer.borderWidth = Metric.imageBorderWidth
//        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
//        imageView.addGestureRecognizer(tapGestureRecognizer)

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
        super.viewWillAppear(animated)
        
        presenter.startCaptureService()
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
