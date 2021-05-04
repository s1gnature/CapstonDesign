//
//  ViewController.swift
//  BarcodeReader
//
//  Created by mong on 2021/04/06.
//

import UIKit
import AVFoundation
import ZBarSDK
import KakaoNewtoneSpeech

class ViewController: UIViewController {
    

    
    @IBOutlet var QRReaderView: ReaderView!
    let reader = ZBarReaderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.QRReaderView.delegate = self
        self.view.addSubview(QRReaderView)

    }
    override func viewDidAppear(_ animated: Bool) {
//        initKakaoTTS()
    }
    override func viewDidLayoutSubviews() {
        initQRReaderView(QRReaderView: QRReaderView)
    }

}

// MARK: - initReaderView
private func initQRReaderView(QRReaderView: ReaderView){
    QRReaderView.start()
}

// MARK: - ReaderView
extension ViewController: ReaderViewDelegate {
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
            self.QRReaderView.start()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.QRReaderView.start()
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
}

extension ViewController: MTTextToSpeechDelegate {
    func onFinished() {
        print("onFinished")
    }
    
    func onError(_ errorCode: MTTextToSpeechError, message: String!) {
        print("onErr")
    }
    
    func initKakaoTTS() -> Void {
        let kakaoTTSConfig = [
//            "TextToSpeechConfigKeySpeechSpeed" : 1,
            "TextToSpeechConfigKeyVoiceType" : "TextToSpeechVoiceTypeWomanDialog"
//            "TextToSpeechConfigServiceMode" : "NewtoneTalk_1"
        ] as! Dictionary<AnyHashable, Any>
        let kakaoTTS = MTTextToSpeechClient(config: kakaoTTSConfig)
        kakaoTTS!.delegate = self
        
        kakaoTTS!.play("이것은 카카오 음성!")
//        kakaoTTS!.play("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ")
    }
}
