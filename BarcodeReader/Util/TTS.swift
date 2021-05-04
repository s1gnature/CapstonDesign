//
//  TTS.swift
//  BarcodeReader
//
//  Created by mong on 2021/05/01.
//

import Foundation
import AVFoundation

class TTS: NSObject, AVSpeechSynthesizerDelegate {
    let speech = AVSpeechSynthesizer()
    var voice: AVSpeechSynthesisVoice!
    var utterance: AVSpeechUtterance!
    
    override init() {
        super.init()
        speech.delegate = self
    }
    func setText(_ s: String) {
        utterance = AVSpeechUtterance(string: s)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        speakVoice()
//        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
    }
    
    func speakVoice() {
        speech.speak(utterance)
    }
}


