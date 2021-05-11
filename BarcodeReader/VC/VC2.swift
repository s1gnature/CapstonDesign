//
//  VC2.swift
//  BarcodeReader
//
//  Created by mong on 2021/05/10.
//

import Foundation
import UIKit

class VC2: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    private var modelDataHandler = ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
    
    override func viewDidLoad() {
        imageView.image = UIImage(named: "sprite")
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let buffer = CVImageBuffer.buffer(from: imageView.image!) else {
            return
        }
        var result = modelDataHandler?.runModel(onFrame: buffer)
        dump(result)
    }
}
