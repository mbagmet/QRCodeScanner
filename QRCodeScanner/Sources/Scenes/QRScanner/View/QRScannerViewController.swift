//
//  QRScannerViewController.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import UIKit

class QRScannerViewController: UIViewController {

    // MARK: - Properties
    
    var presenter = QRScannerPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Presenter setup
        presenter.setViewDelegate(delegate: self)
        
        // MARK: View Setup
        view.backgroundColor = .systemTeal
    }
}

// MARK: - Presenter Delegate

extension QRScannerViewController: QRScannerPresenterDelegate {

}
