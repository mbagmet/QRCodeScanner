//
//  QRScannerPresenterDelegate.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

protocol QRScannerPresenterDelegate: AnyObject {
    func showWebView(with url: URL)
    
    func showAlert(openSettings: Bool, message: String)
}
