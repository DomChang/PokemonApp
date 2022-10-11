//
//  HTTPClient.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/29.
//

import UIKit

enum HTTPError: Error {
    
    case urlError
    
    case decodeDataFail
    
    case clientError
    
    case serverError
    
    case internetError
    
    case unexpectedError
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let decoder = JSONDecoder()
    
    private let encoder = JSONEncoder()
    
    private init() { }
    
    func requestData(baseUrl: String, paging: Int?,
                     completion: @escaping (Result<Data, Error>) -> Void) {
        
        var parameters: [String: String] = [:]
        
        guard var component = URLComponents(string: baseUrl) else {
            
            return completion(.failure(HTTPError.urlError))
        }
        
        if let paging = paging {
            
            parameters = ["limit": "20",
                          "offset": String(20 * paging)]
            
            component.queryItems = parameters.map { (key, value) in
                
                URLQueryItem(name: key, value: value)
            }
        }
        
        let request = URLRequest(url: component.url!)
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    
                    return completion(Result.failure(error!))
                }
                
                let httpResponse = response as! HTTPURLResponse
                
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                    
                case 200..<300:
                    
                    completion(.success(data!))
                    
                case 400..<500:
                    
                    completion(.failure(HTTPError.clientError))
                    
                case 500..<600:
                    
                    completion(.failure(HTTPError.serverError))
                    
                default:
                    completion(.failure(HTTPError.unexpectedError))
                }
                
            }).resume()
    }
}
