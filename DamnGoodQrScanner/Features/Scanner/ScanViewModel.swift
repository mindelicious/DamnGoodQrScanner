//
//  ScanViewModel.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 03/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanViewModelDelegate: class {
    func didFinishCaptureData(_ stringValue: String)
    func isScanning(_ boolValue: Bool)
}

class ScanViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: ScanViewModelDelegate?
    var captureSession = AVCaptureSession()
 
    func startCapturing() {
        captureSession.startRunning()
        delegate?.isScanning(true)
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
          return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
          return
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didFinishCaptureData(stringValue)
            delegate?.isScanning(false)
        }
    }

}
