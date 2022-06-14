//
//  ScanResultsPresenter.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

class ScanResultsPresenter: ScanResults {
    
    // MARK: - Properties
    
    weak var delegate: ScanResultsPresenterDelegate?
    
    // MARK: - Configuration
    
    func setViewDelegate(delegate: ScanResultsPresenterDelegate) {
        self.delegate = delegate
    }
}
