//
//  CaptureProviderDelegate.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 17.06.2022.
//

import Foundation

protocol CaptureProviderDelegate: AnyObject {
    func handleUrl(url: URL)
    
    func handleResultMessage(result: CaptureProvider.CameraConfiguration)
}
