//
//  JSONService.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

/**
 A class meant to be inherited by `Service` classes. This class helps encode JSON requests and decodes JSON responses. This class should never be used directly from a view model.
 
 Use the `request` function in this class to make HTTP requests.
 */
class JSONService {
    // MARK: - Properties
    ///IMPORTANT NOTE: `JSONService` can only handle one network call at a time
    private var urlDataTask: URLSessionDataTask? = nil
    
    // MARK: - Enums
    /// Used to specify the type of request that should be made
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    // MARK: - Functions
    /**
     Fetch JSON data and parse it according to the `type` parameter in the function. In other words, the `url` must return JSON that maps to `type`.
     
     All requests made through this function have 15 seconds to receive a response, otherwise the request will timeout.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter requestType: Specifies the type of request using the `RequestType` enum. Defaults to `GET`
     - parameter body: If this parameter is included, the dictionary is sent in the http body. Defaults to `nil`
     - parameter type: The structure that the fetched JSON data should be parsed according to. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes an error object instead.
     */
    func request<T: Decodable>(from urlString: String,
                               requestType: RequestType = .get,
                               body: [String : Any]? = nil,
                               expecting type: T.Type,
                               completion: @escaping (Result<T>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                completion(.error(NSError(domain: "Could not serialize http body", code: 0, userInfo: nil)))
                return
            }
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        //This class only supports running one network request at a time so if there is a request currently in progress, cancel it.
        urlDataTask?.cancel()
        
        let newSession = URLSession.self
        
        urlDataTask = newSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            do {
                if let response = response as? HTTPURLResponse, response.statusCodeIsError {
                    let json = try JSONDecoder().decode(JSONError.self, from: data)
                    completion(.error(NSError(domain: json.errors, code: response.statusCode, userInfo: nil)))
                    return
                }
    
                let json = try JSONDecoder().decode(type, from: data)

                completion(.success(json))
            } catch {
                completion(.error(NSError(domain: "Could not decode JSON", code: 0, userInfo: nil)))
            }
        }
        urlDataTask?.resume()
    }
}
