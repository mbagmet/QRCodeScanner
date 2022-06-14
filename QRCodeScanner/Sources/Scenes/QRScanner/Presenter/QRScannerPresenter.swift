//
//  QRScannerPresenter.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

class QRScannerPresenter: QRScanner {
    
    // MARK: - Properties
    
    weak var delegate: QRScannerPresenterDelegate?
    
    // MARK: - Configuration
    
    func setViewDelegate(delegate: QRScannerPresenterDelegate) {
        self.delegate = delegate
    }
}
