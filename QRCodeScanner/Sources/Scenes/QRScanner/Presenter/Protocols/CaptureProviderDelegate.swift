//
//  CaptureProviderDelegate.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 17.06.2022.
//

import Foundation

protocol CaptureProviderDelegate: AnyObject {
    func openWebView(with url: URL)
    
    func openAlert(openSettings: Bool, message: String)
}
