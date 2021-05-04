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
        return "\(barcode)\n\(productName)\n\(categoryName)\n\(categoryDetailName)"
    }
    func ttsValue() -> String {
        return "\(productName). \(categoryName). \(categoryDetailName)."
    }
}


