//
//  ScanResultsViewController.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import UIKit
import WebKit

class ScanResultsViewController: UIViewController, WKUIDelegate {

    // MARK: - Properties
    
    var presenter = ScanResultsPresenter()
    
    // MARK: - Views
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.sizeToFit()
        
        return progressView
    }()
    
    // MARK: - Lifecycle
    
    var webView: WKWebView!
        
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "webView.title"
        
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Presenter setup
        presenter.setViewDelegate(delegate: self)
        presenter.getUrl()
        
        // MARK: View setup
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        progressView.removeFromSuperview()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        navigationController?.navigationBar.addSubview(progressView)
    }
    
    private func setupLayout() {
        progressView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    // MARK: Oserve webView loading progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if webView.estimatedProgress == 1.0 {
                progressView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Private functions
    
    private func addObserver() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
}

// MARK: - Presenter Delegate

extension ScanResultsViewController: ScanResultsPresenterDelegate {
    func showWebPage(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
