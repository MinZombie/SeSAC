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
        
        static let baseUrl = "api.openweathermap.org/data/2.5/"
    }
    
    // MARK: - Private
    private enum Endpoint: String {
        case weather
    }
    
    
    
    func fetchData<T: Codable>(latitude: Double, longitude: Double, model: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        
        let urlString = Constants.baseUrl + Endpoint.weather.rawValue + "?lat=\(latitude)&long=\(longitude)&appid=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
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
