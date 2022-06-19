//
//  ScanResultsPresenterDelegate.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

protocol ScanResultsPresenterDelegate: AnyObject {
    func showWebPage(url: URL)
}
