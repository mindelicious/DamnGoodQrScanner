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

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var captureLabel = makeCaptureLabel()
    lazy var captureButton = makeCaptureButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startCapturing()
    }
    
    @objc func capturePhoto(sender: UIButton) {
        captureSession.startRunning()
        captureLabel.text = ""
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        captureLabel.text = captureSession.isRunning ? "" : code
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ScanViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 1.4)
        previewLayer.videoGravity = .resizeAspectFill
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
    
    func startCapturing() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
           videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
           return
        }

        if (captureSession.canAddInput(videoInput)) {
           captureSession.addInput(videoInput)
        } else {
           failed()
           return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
           captureSession.addOutput(metadataOutput)

           metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
           metadataOutput.metadataObjectTypes = [.qr]
        } else {
           failed()
           return
        }
        captureSession.startRunning()
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
