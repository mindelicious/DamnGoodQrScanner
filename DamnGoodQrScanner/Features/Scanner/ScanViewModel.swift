//
//  ScanViewModel.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 03/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanViewModelDelegate {
    func didFinishCaptureData(_ stringValue: String)
    func failedCaptureData(_ message: String)
}

class ScanViewModel {
    
    var delegate: ScanViewModelDelegate?
    var captureSession = AVCaptureSession()
//    var previewLayer = AVCaptureVideoPreviewLayer()
   
    func startCapturing() {
        captureSession.startRunning()
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
            delegate?.failedCaptureData("Can't scan QR code")
          return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            delegate?.failedCaptureData("Can't scan QR code")

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
            
        }
    }
    

}
