//
//  ScanResults.swift
//  QRCodeScanner
//
//  Created by Михаил Багмет on 14.06.2022.
//

protocol ScanResults {
    var view: ScanResultsPresenterDelegate? { get set }
    
    func setViewDelegate(delegate: ScanResultsPresenterDelegate)
    func getUrl()
}
