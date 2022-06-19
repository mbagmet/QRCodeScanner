//
//  ScanResultsPresenter.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

class ScanResultsPresenter: ScanResults {
    
    // MARK: - Properties
    
    weak var view: ScanResultsPresenterDelegate?
    var url: URL?
    
    // MARK: - Configuration
    
    func setViewDelegate(delegate: ScanResultsPresenterDelegate) {
        self.view = delegate
    }
    
    func getUrl() {
        guard let url = url else { return }
        view?.showWebPage(url: url)
    }
}
