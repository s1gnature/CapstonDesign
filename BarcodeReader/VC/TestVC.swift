//
//  VC2.swift
//  BarcodeReader
//
//  Created by mong on 2021/05/10.
//

import Foundation
import UIKit
import AVFoundation

class TestVC: UIViewController {
    @IBOutlet var testReaderView: ReaderView!
    @IBOutlet var testImageView: UIImageView!
    @IBOutlet var productRankLabelStack: UIStackView!
    
    private var modelDataHandler = ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
    
    override func viewDidLoad() {
        self.testReaderView.delegate = self
        self.view.addSubview(testReaderView)
    }
    override func viewDidLayoutSubviews() {
        initReaderView(readerView: testReaderView)
    }
    
    @IBAction func videoRunningSwitch(_ sender: UISwitch) {
        /*
        if sender.isOn {
            testReaderView.isVideoRunning = true
            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .code128, .code93, .code39, .code39Mod43]
            metadataOutput.setMetadataObjectsDelegate(testReaderView, queue: DispatchQueue.main)
            testReaderView.captureSession?.addOutput(metadataOutput)
        }
        else {
            testReaderView.isVideoRunning = false
            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .code128, .code93, .code39, .code39Mod43]
            metadataOutput.setMetadataObjectsDelegate(testReaderView, queue: DispatchQueue.main)
            testReaderView.captureSession?.removeOutput(metadataOutput)
        }
 */
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func captureBtn(_ sender: Any) {
        let image = testReaderView.capturePhoto()
    }
    
}


// MARK: - initReaderView
private func initReaderView(readerView: ReaderView){
    readerView.start()
}

// MARK: - ReaderView
extension TestVC: ReaderViewDelegate {
    func captureComplete(image: UIImage?) {
        guard let image = image?.resized(to: CGSize(width: 224, height: 224)) else {
            print("## Captured Image is Nil")
            return
        }
//        var imageData = UIImage(named: "coke")
        self.testImageView.image = image
        guard let buffer = CVImageBuffer.buffer(from: image) else {
            return
        }
        guard let imageBuffer = getBuffer(from: image) else {
            print("## ???")
            return
        }
        if let result = modelDataHandler?.runModel(onFrame: buffer) {
            dump(result)
            
            for idx in 0..<3 {
                let label = productRankLabelStack.arrangedSubviews[idx] as! UILabel
                label.text = "\(result.inferences[idx].label): \(result.inferences[idx].confidence * 100)%"
            }
        }
    }
    
    func readerComplete(status: ReaderStatus) {
        var title = ""
        var message = ""
        var alert = UIAlertController()
        
        switch status {
        case let .success(code):
            print("# Success")
            guard let code = code else {
                title = "error"
                message = "recognize failure"
                break
            }
            title = "success"
            message = code
            
            var productValue: ProductVO?
            
            let statusCode = NetworkManager().searchBarcode(barcode: code) { (value) in
                productValue = value
                print(productValue?.stringValue())
            }
            switch statusCode {
            case .success:
                alert = UIAlertController(title: "", message: productValue!.stringValue(), preferredStyle: .alert)
                print(productValue!.stringValue())
                TTS().setText(productValue!.ttsValue())
            case .fail:
                alert = UIAlertController(title: "", message: "정보가 없는 식음료 입니다", preferredStyle: .alert)
                TTS().setText("정보가 없는 식음료 입니다.")
            case .serverErr:
                alert = UIAlertController(title: "", message: "잠시 후 다시 스캔 해 주세요", preferredStyle: .alert)
                TTS().setText("잠시 후 다시 스캔 해 주세요.")
            }
            
        case .fail:
            title = "fail"
            message = "recongize failure"
        case let .stop(isButtonTap):
            title = "stop"
            message = "recongize failure"
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {(_) in
            self.testReaderView.start()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.testReaderView.start()
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
