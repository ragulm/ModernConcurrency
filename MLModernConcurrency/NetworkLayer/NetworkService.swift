//
//  NetworkService.swift
//  MLModernConcurrency
//
//  Created by M L Ragul on 16/04/25.
//

import Foundation
import Combine

protocol NetworkServiceProvider {
    func fetchCompaniedWithPublisher() -> AnyPublisher<[CompanyModel], Error>
    func fetchCompaniedWithAsyncAwait() async throws -> [CompanyModel]
}

class NetworkService: NetworkServiceProvider {
    
    let apiClient = NetworkServiceAPIClient<DataEndpoint>()
    
    func fetchCompaniedWithPublisher() -> AnyPublisher<[CompanyModel], any Error> {
        apiClient.request(.getcompanies)
    }
    
    func fetchCompaniedWithAsyncAwait() async throws -> [CompanyModel] {
        let getData: [CompanyModel] = try await apiClient.requestWithAsync(.getcompanies)
        return getData
    }
}
