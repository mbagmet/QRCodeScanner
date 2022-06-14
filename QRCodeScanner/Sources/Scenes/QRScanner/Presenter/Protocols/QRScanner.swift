//
//  QRScanner.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

protocol QRScanner {
    var delegate: QRScannerPresenterDelegate? { get set }
    
    func setViewDelegate(delegate: QRScannerPresenterDelegate)
}