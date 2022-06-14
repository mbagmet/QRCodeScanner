//
//  ScanResults.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

import Foundation

protocol ScanResults {
    var delegate: ScanResultsPresenterDelegate? { get set }
    
    func setViewDelegate(delegate: ScanResultsPresenterDelegate)
}
