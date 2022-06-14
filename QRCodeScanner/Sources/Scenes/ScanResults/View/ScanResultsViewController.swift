//
//  ScanResultsViewController.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import UIKit

class ScanResultsViewController: UIViewController {

    // MARK: - Properties
    
    var presenter = ScanResultsPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Presenter setup
        presenter.setViewDelegate(delegate: self)
        
        // MARK: View Setup
        view.backgroundColor = .systemPink
    }
}

// MARK: - Presenter Delegate

extension ScanResultsViewController: ScanResultsPresenterDelegate {
    
}
