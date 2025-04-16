//
//  Networklayer+APIClient.swift
//  MLModernConcurrency
//
//  Created by M L Ragul on 16/04/25.
//

import Foundation
import Combine

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
    func requestWithAsync<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

class NetworkServiceAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    
    func request<T>(_ endpoint: EndpointType) -> AnyPublisher<T, any Error> where T : Decodable {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        let dataPublisher = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return dataPublisher
    }
    
    func requestWithAsync<T>(_ endpoint: EndpointType) async throws -> T where T : Decodable {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
