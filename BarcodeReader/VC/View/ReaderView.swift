//
//  ReaderView.swift
//  QRReader
//
//  Created by mong on 2021/02/03.
//

import Foundation
import UIKit
import AVFoundation

enum ReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: class {
    func readerComplete(status: ReaderStatus)
    func captureComplete(image: UIImage?)
}

class ReaderView: UIView {
    weak var delegate: ReaderViewDelegate?
    var isVideoRunning = true
    
    // 동영상 화면을 보여줄 Layer
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    let photoOutput = AVCapturePhotoOutput()
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        return captureSession.isRunning
    }
    
    // 촬영 시 어떤 데이터를 검사할건지? - QRCode
    var metadataObjectTypes: [AVMetadataObject.ObjectType] = [.ean8, .ean13]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    /// AVCaptureSession을 실행하는 화면을 구성 후 실행합니다.
    private func initialSetupView() {
        self.clipsToBounds = true
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
                
        let metadataOutput = AVCaptureMetadataOutput()
                
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
                    
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
            
        } else {
            self.fail()
            return
        }
                
        // MARK: - Setup PhotoOutput
        
        photoOutput.isHighResolutionCaptureEnabled = true
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }else {
            print("photo fail")
            self.fail()
            return
        }

        self.setPreviewLayer()
        self.start()
    }
    
    /// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
    private func setPreviewLayer() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        /*
         AVCaptureVideoPreviewLayer를 구성.
         */
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
}

// MARK: - ReaderView Running Method
extension ReaderView {
    func start() {
        print("# AVCaptureSession Start Running")
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) {
        self.captureSession?.stopRunning()
        
        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.captureSession?.stopRunning()
        self.delegate?.readerComplete(status: .success(code))
    }
    
    func capturePhoto() {
        var capturedPhotoImage: UIImage?
        self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

// MARK: - AVCapture Output
extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        print("# GET metadataOutput")
//        stop(isButtonTap: false)
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            print("## Found metadata Value\n + \(stringValue)\n")
//            stop(isButtonTap: true)
        }
    }
    
}

// MARK: - Capture Photo
extension ReaderView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        AudioServicesDisposeSystemSoundID(1108)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        guard let photoData = photo.fileDataRepresentation() else {
            print("## Get PhotoData Failure")
            return
        }
        guard let UIImageData = UIImage(data: photoData) else {
            print("## Get UIImageData Failure")
            return
        }
        if let capturedPhotoImage = UIImage(data: photoData) {
            self.delegate?.captureComplete(image: capturedPhotoImage)
        }else {
            print("## Capture Photo Failrue")
            self.delegate?.captureComplete(image: nil)
        }
    }
}
