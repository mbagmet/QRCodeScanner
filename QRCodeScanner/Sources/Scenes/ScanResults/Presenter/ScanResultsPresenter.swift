//
//  ScanResultsPresenter.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import WebKit

class ScanResultsPresenter: ScanResults {
    
    // MARK: - Properties
    
    weak var view: ScanResultsPresenterDelegate?
    var url: URL?
    //var url = URL(string: "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf")
    
    private var mimeTypes = [MimeType(type: "pdf", fileExtension: "pdf")]
    private var fileDownloadProvider: FileDownloadProvider?
    
    // MARK: - Configuration
    
    func setViewDelegate(delegate: ScanResultsPresenterDelegate) {
        self.view = delegate
    }
    
    func getUrl() {
        guard let url = url else { return }
        view?.getDownloadProwider()
        view?.showWebPage(url: url)
    }
    
    // MARK: - Work with FileDownloadProvider
    
    func initDownloadProvider(webView: WKWebView) {
        fileDownloadProvider = FileDownloadProvider(delegate: self, mimeTypes: mimeTypes, webView: webView)
    }
    
    func startDownloading() {
        guard let url = url else { return }
        fileDownloadProvider?.downloadFile(url: url) {tempPath in
            self.view?.showActivityViewController(objectsToShare: [tempPath])
        }
    }
    
    // MARK: - Methods
    
    func isDownloadable() -> Bool {
        guard let isDownloadable = fileDownloadProvider?.canDownload else { return false }
        return isDownloadable
    }
}

// MARK: - FileDownloadProviderDelegate

extension ScanResultsPresenter: FileDownloadProviderDelegate {
    func setCanDownload() {
        fileDownloadProvider?.canDownload = true
    }
}
