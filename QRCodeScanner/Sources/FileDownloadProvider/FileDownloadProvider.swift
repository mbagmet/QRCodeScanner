//
//  FileDownloadProvider.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 19.06.2022.
//

import WebKit
import Alamofire

class FileDownloadProvider: NSObject {

    // MARK: - Properties
    
    weak var delegate: FileDownloadProviderDelegate?
    var mimeTypes: [MimeType]
    
    var webView: WKWebView?
    
    var canDownload = false
    
    // MARK: - Initializers
    
    init(delegate: FileDownloadProviderDelegate, mimeTypes: [MimeType], webView: WKWebView) {
        self.delegate = delegate
        self.mimeTypes = mimeTypes
        self.webView = webView
        
        super.init()
        webView.navigationDelegate = self
    }
    
    // MARK: - Methods
    
    func downloadFile(url: URL, completion: @escaping (NSURL) -> ()) {

        let fileName = getFileNameFromUrl(url: url)
        
        let destinationPath: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(fileName)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(url, to: destinationPath).responseURL { response in
            
            if response.error == nil, let tempPath = response.fileURL?.path {
                let fileURL = NSURL(fileURLWithPath: tempPath)
                completion(fileURL)
            }
        }
    }

    // MARK: - Private functions
    
    private func isMimeTypeConfigured(_ mimeType: String) -> Bool {
        for record in self.mimeTypes {
            if mimeType.contains(record.type) {
                return true
            }
        }
        return false
    }
    
    private func getFileNameFromUrl(url: URL) -> String {
        let fileName = url.absoluteString.components(separatedBy: "/").last
        return fileName ?? "temp.pdf"
    }
}

// MARK: - WKNavigationDelegate

extension FileDownloadProvider: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let mimeType = navigationResponse.response.mimeType else { return }
        
        if isMimeTypeConfigured(mimeType) {
            if navigationResponse.response.url != nil {
                delegate?.setCanDownload()
                
                decisionHandler(.allow)
            }
            return
        }
        decisionHandler(.allow)
    }
}
