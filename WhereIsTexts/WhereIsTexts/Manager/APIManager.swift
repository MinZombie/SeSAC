//
//  APIManager.swift
//  WhereIsTexts
//
//  Created by 민선기 on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON



final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    
    private struct Constants {
        static var apiKey: String {
            (Bundle.main.infoDictionary?["API_KEY"] as? String) ?? ""
        }
        
        static let baseUrl = "https://dapi.kakao.com/v2/vision/text/ocr"
        static let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": Constants.apiKey
        ]
    }
    
    
    
    func request(image: UIImage, completion: @escaping (JSON) -> ()) {
        guard let imageData = image.pngData() else { return }

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(
                imageData,
                withName: "image",
                fileName: "image"
            )
        },
                  to: Constants.baseUrl,
                  headers: Constants.header)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    
                    completion(json)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
