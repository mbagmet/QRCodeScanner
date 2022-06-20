//
//  DownloadProvider.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 20.06.2022.
//

import WebKit

protocol DownloadProvider {
    var delegate: FileDownloadProviderDelegate? { get set }
    var mimeTypes: [MimeType] { get set }
    
    var webView: WKWebView? { get }
    
    var canDownload: Bool { get set }
    
    func downloadFile(url: URL, completion: @escaping (NSURL) -> ())
}

struct MimeType {
    var type: String
    var fileExtension: String
}
