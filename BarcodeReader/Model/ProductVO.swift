//
//  ProductVO.swift
//  BarcodeReader
//
//  Created by mong on 2021/04/14.
//

import Foundation
import UIKit

struct ProductVO: Codable {
    let id: Int
    let barcode: String
    let productName: String
    let categoryName: String
    let categoryDetailName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case barcode = "barcode"
        case productName = "name"
        case categoryName = "HRNK_PRDLST_NM"
        case categoryDetailName = "PRDLST_NM"
    }
    
    func stringValue() -> String {
        return "바코드 번호: \(barcode)\n제품명: \(productName)\n분류: \(categoryDetailName)"
    }
    func ttsValue() -> String {
        return "\(productName). \(categoryDetailName)."
    }
}


