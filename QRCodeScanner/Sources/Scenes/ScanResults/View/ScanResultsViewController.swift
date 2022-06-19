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
    
    // MARK: - Lifecycle
    
    var webView: WKWebView!
        
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
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
    }
}

// MARK: - Presenter Delegate

extension ScanResultsViewController: ScanResultsPresenterDelegate {
    func showWebPage(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
