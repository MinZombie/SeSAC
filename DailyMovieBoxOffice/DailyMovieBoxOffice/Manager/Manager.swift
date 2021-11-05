//
//  Manager.swift
//  DailyMovieBoxOffice
//
//  Created by 민선기 on 2021/11/03.
//

import Foundation

import Alamofire
import SwiftyJSON

final class Manager {
    static let shared = Manager()
    
    private init() {}
    
    private struct Constants {
        static var apiKey: String {
            (Bundle.main.infoDictionary?["API_KEY"] as? String) ?? ""
        }
        
        static let baseUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    }
    
    public func request (date: String, completion: @escaping (MoviesResponse) -> ()) {
        let url = Constants.baseUrl + "key=\(Constants.apiKey)&targetDt=\(date)"

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }

                do {
                    let result = try JSONDecoder().decode(MoviesResponse.self, from: data)
                    completion(result)
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
