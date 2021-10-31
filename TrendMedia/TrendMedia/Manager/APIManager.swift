//
//  APIManager.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/28.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    struct Constants {
        static var apiKey: String {
            (Bundle.main.infoDictionary?["API_KEY"] as? String) ?? ""
        }
        
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let imageBaseUrl = "https://image.tmdb.org/t/p/original"
    }
    
    // MARK: - Public
    public func getDailyMovieTrend(startPage: Int, completion: @escaping (TrendingResponse) -> Void) {
        
        fetchData(url: url(endpoint: .dailyMovieTrend, queryParameters: ["page" : "\(startPage)"]), model: TrendingResponse.self, completion: completion)
    }
    
    public func getGenre(completion: @escaping (Genres) -> Void) {
        fetchData(url: url(endpoint: .movieGenreList), model: Genres.self, completion: completion)
    }
    
    
    
    // MARK: - Private
    private enum Endpoint: String {
        case dailyMovieTrend = "trending/movie/day"
        case movieGenreList = "genre/movie/list"
        case credit
    }
    
    private func url(endpoint: Endpoint, movieId: String? = nil, queryParameters: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl
        var queryItems = [URLQueryItem]()
        
        switch endpoint {
        case .dailyMovieTrend, .movieGenreList:
            urlString += endpoint.rawValue
            
        case .credit:
            urlString += endpoint.rawValue
            
        }
        
        for (name, value) in queryParameters {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "api_key", value: Constants.apiKey))
        
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")

        return URL(string: urlString)
    }
    
    private func fetchData<T: Codable>(url: URL?, model: T.Type, completion: @escaping (T) -> Void) {
        
        guard let url = url else {
            // 유효하지 않은 url
            return
        }
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }
                
                do {
                    
                    let result = try JSONDecoder().decode(model, from: data)
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
