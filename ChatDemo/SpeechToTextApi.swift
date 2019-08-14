//
//  SpeechToTextApi.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 01/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import SpeechToTextV1

class SpeechToTextApi: RecognitionApi {
    let sdkInstance: SpeechToText
    let language: String
    var accumulator = SpeechRecognitionResultsAccumulator()
    
    @IBOutlet weak var textView: UITextView!
    
    init(username: String,
         password: String,
         language: String) {
        self.sdkInstance = SpeechToText(username: username, password: password)
        self.language = language
    }
    
    func startRecognition(success: @escaping (String) -> Void,
                          failure: ((String) -> Void)?) {
 
        
        var callback = RecognizeCallback()
        callback.onError = { error in
            failure?((error as Error).customMessage()!)
        }
        callback.onResults = { results in
            self.accumulator.add(results: results)
            print(self.accumulator.bestTranscript)
            self.textView.text = self.accumulator.bestTranscript
        }
        
        
        sdkInstance.recognizeMicrophone(settings: defaultSettings(),
                                        callback: callback
        )
    }
    
    func stopRecognition() {
        sdkInstance.stopRecognizeMicrophone()
    }
    
    private func defaultSettings() -> RecognitionSettings {
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        // settings.continuous = true
        return settings
    }
}
