//
//  ViewController.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 02/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit
import SnapKit
import SwiftQRScanner

class ScanViewController: UIViewController {
    
    lazy var scanImage = makeImage()
    lazy var scanButton = makeButton()
    
    let scanner =  QRCodeScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        scanner.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc func openCamera(sender: UIButton) {
    self.present(scanner, animated: true, completion: nil)
    }

}

extension ScanViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        [scanImage, scanButton].forEach { view.addSubview($0)}
        
        scanImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        scanButton.snp.makeConstraints { make in
            make.top.equalTo(scanImage.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(38)
        }
    }
    
    func makeImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "qrIcon")
        return imageView
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.setTitle("SCAN", for: .normal)
        button.setTitleColor(UIColor(named: "pastelPurple"), for: .normal)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 7.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.7, height: 0.7)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 1.0
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor(named: "pastelPurple")?.cgColor
        button.backgroundColor = UIColor(named: "lightBlue")
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        return button
    }
}

extension ScanViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
    }

    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }

    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
