//
//  ScanResultsPresenterDelegate.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

protocol ScanResultsPresenterDelegate: AnyObject {
    func getDownloadProwider()
    func showWebPage(url: URL)
    func showActivityViewController(objectsToShare: [Any])
}
