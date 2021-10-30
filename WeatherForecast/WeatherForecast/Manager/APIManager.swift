//
//  APIManager.swift
//  WeatherForecast
//
//  Created by 민선기 on 2021/10/27.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    private struct Constants {
        static var apiKey: String {
            (Bundle.main.infoDictionary?["API_KEY"] as? String) ?? ""
        }
        
        static let baseUrl = "https://api.openweathermap.org/"
    }
    
    
    public func fetchWeather(lat: String, lon: String, completion: @escaping (Result<WeatherResult, Error>) -> ()) {
        guard let url = url(endpoint: .weather, queryParameters: ["lat": lat, "lon": lon]) else { return }
        
        fetch(url: url, model: WeatherResult.self, completion: completion)
    }

    
    // MARK: - Private
    private enum Endpoint: String {
        case weather = "data/2.5/weather"
        case iconImage = "img/wn/"
    }
    
    private func url(endpoint: Endpoint, queryParameters: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        for (name, value) in queryParameters {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "appid", value: Constants.apiKey))
        
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        return URL(string: urlString)
    }
    
    private func fetch<T: Codable>(url: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(model, from: data)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
                print(error)
                
            }
            
        }
        dataTask.resume()
    }
    
}
