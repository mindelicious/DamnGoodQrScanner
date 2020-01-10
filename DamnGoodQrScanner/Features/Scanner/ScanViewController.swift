//
//  ViewController.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 02/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import AVFoundation
import UIKit
import SnapKit

class ScanViewController: UIViewController {
    
    private let viewModel: ScanViewModel
    
    lazy var captureLabel = makeCaptureLabel()
    lazy var captureButton = makeCaptureButton()
    lazy var previewLayer = makePreviewLayer()

    init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel.startCapturing()
    }
    
    @objc func capturePhoto(sender: UIButton) {
        viewModel.startCapturing()
//        viewModel.captureSession.startRunning()
//        captureLabel.text = ""
    }

    
   
//    func found(code: String) {
//        captureLabel.text = viewModel.captureSession.isRunning ? "" : code
//    }
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ScanViewController {
    
    func setupUI() {
        
        viewModel.delegate = self
        
        view.backgroundColor = UIColor.white

        view.layer.addSublayer(previewLayer)
       
        [captureLabel, captureButton].forEach { view.addSubview($0) }
        
        captureButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
        captureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(captureButton.snp.top).offset(-20 )
        }
    }
    
    func makePreviewLayer() -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 1.4)
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
    
    func makeCaptureLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    
    func makeCaptureButton() -> UIButton {
       let button = UIButton()
       button.setImage(UIImage(named: "camera"), for: .normal)
       button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
       return button
    }
}

extension ScanViewController: ScanViewModelDelegate {
    
    func didFinishCaptureData(_ stringValue: String) {
        captureLabel.text = stringValue
    }
    
    func failedCaptureData(_ message: String) {
        let ac = UIAlertController(title: "What the heck?", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Again", style: .default))
            present(ac, animated: true)
    }
}
