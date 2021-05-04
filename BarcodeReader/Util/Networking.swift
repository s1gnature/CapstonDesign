//
//  Networking.swift
//  BarcodeReader
//
//  Created by mong on 2021/04/14.
//

import Foundation

enum HttpMethod: String {
    case POST = "POST"
    case GET = "GET"
    
    var value: String {
        return rawValue
    }
}
enum StatusCode {
    case success
    case fail
    case serverErr
}

class NetworkManager {
    func searchBarcode(barcode: String, completion: @escaping(ProductVO) -> Void) -> StatusCode {
        guard let url = URL(string: serverAddress + barcode) else {return .fail}
        let statusCode = networkSession(method: .GET, url: url, completion: {(data, urlResponse, error) in
            if let data = data, let decodeData = try? JSONDecoder().decode(ProductVO.self, from: data) {
                if decodeData == nil {
                    let dataString = String(data: data, encoding: .utf8)!
                    completion(ProductVO(id: -1, barcode: dataString, productName: dataString, categoryName: dataString, categoryDetailName: dataString))
                }else {
                    completion(decodeData)
                }
            }else {
                print("## NO Barcode Data")
            }
        })
        return statusCode
    }
    
    
    private func networkSession(method: HttpMethod, url: URL, data: Data = Data(), completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> StatusCode {
        let semaphore = DispatchSemaphore(value: 0)
        var statusCode: Int = 400
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.value
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            } else {
                print("no response")
                completion(data, response, error)
            }
            completion(data, response, error)
            semaphore.signal()
        }
        
        dataTask.resume()
        semaphore.wait()
        switch statusCode {
        case 200...299:
            return .success
        case 400...499:
            return .fail
        default:
            return .serverErr
        }
    }
}
