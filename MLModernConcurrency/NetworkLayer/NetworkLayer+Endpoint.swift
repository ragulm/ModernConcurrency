//
//  NetworkLayer+Endpoint.swift
//  MLModernConcurrency
//
//  Created by M L Ragul on 16/04/25.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum DataEndpoint: APIEndpoint {
    case getUsers
    case getcompanies
    
    var baseURL: URL {
        return URL(string: "https://fake-json-api.mock.beeceptor.com")!
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getcompanies:
            return "/companies"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getcompanies:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUsers, .getcompanies:
            return ["Authorization": "Bearer TOKEN"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUsers, .getcompanies:
            return ["page": 1, "limit": 10]
        }
    }
}
