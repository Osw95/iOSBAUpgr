//
//  ApiManager.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit

enum APIResult<T: Decodable> {
    case success(T)
    case failure(Error)
}


final class ApiManager {
    
    private let urlBase = "https://api.tvmaze.com/"
    
    ///  Loads de data from api and it parse the data to a generic type "T"
    /// - Parameters:
    ///   - resource: Url that would be consulted
    ///   - completion:  A closure that would be executed when the operation is completed
    func load<T: Decodable>(resource: String?, completion: @escaping (APIResult<[T]>) -> ()) {
        
        var task:URLSessionDataTask!
        
        guard let urlSearch = resource else { return }
        
        let urlConstructor = urlBase + urlSearch
        
        let url = URL(string: urlConstructor)
        
        guard let url =  url else { return }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                
                completion(.failure(error))
                
                return
            }
            
            if let data = data {
                do{
                    
                    let decoder = JSONDecoder()
                
                    let object = try decoder.decode([T].self, from: data)
                    
                    completion(.success(object))
                    
                }catch{
                    
                    completion(.failure(error))
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
