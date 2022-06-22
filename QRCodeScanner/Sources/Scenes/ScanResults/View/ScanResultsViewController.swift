//
//  ScanResultsViewController.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import UIKit
import WebKit

class ScanResultsViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties
    
    var presenter = ScanResultsPresenter()
    
    // MARK: - Views
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.sizeToFit()
        
        return progressView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    var webView: WKWebView!
        
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Presenter setup
        presenter.setViewDelegate(delegate: self)
        presenter.getUrl()
        
        // MARK: View setup
        setupHierarchy()
        setupLayout()
        setupToolbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        progressView.removeFromSuperview()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        navigationController?.navigationBar.addSubview(progressView)
        
        webView.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        progressView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupToolbar() {
        self.navigationController?.setToolbarHidden(false, animated: true)

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openSharePanel))
        self.toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                     shareButton]
    }
    
    // MARK: - Methods
    
    // MARK: Oserve webView loading progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if webView.estimatedProgress == 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.progressView.removeFromSuperview()
                })
            }
        }
        
        if keyPath == #keyPath(WKWebView.title) {
            title = webView.title
        }
    }
    
    // MARK: - Private functions
    
    private func addObserver() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    @objc private func openSharePanel(sender: AnyObject) {
        
        activityIndicator.startAnimating()
        
        if presenter.isDownloadable() {
            presenter.startDownloading()
        } else {
            showActivityViewController(objectsToShare: [presenter.url!])
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: NSLocalizedString("DISMISS_BUTTON_TITLE", comment: ""),
                                   style: .default,
                                   handler: nil)
        alert.addAction(button)
        
        present(alert, animated: true)
    }
}

// MARK: - Presenter Delegate

extension ScanResultsViewController: ScanResultsPresenterDelegate {
    
    func getDownloadProvider() {
        presenter.initDownloadProvider(webView: webView)
    }
    
    func showWebPage(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func showActivityViewController(objectsToShare: [Any]) {
        
        let objectsToShare = objectsToShare

        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.navigationController?.toolbar
        
        activityController.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?,
                                                                       completed: Bool,
                                                                       returnedItems: [Any]?,
                                                                       error: Error?) in
            if !completed {
                guard let error = error else { return }
                activityController.dismiss(animated: true)
                self?.showAlert(title: NSLocalizedString("FAILURE_MESSAGE_TITLE", comment: ""),
                               message: error.localizedDescription)
            }
            self?.showAlert(title: NSLocalizedString("SUCCESS_MESSAGE_TITLE", comment: ""),
                           message: NSLocalizedString("SUCCESS_MESSAGE", comment: ""))
        }
        
        present(activityController, animated: true, completion: nil)
        
        activityIndicator.stopAnimating()
    }
}
