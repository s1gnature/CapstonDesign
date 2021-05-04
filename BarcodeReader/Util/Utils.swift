//
//  Utils.swift
//  BarcodeReader
//
//  Created by mong on 2021/04/14.
//

import Foundation
import UIKit


func simpleAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
}
