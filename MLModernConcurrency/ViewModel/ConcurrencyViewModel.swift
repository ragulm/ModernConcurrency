//
//  ConcurrencyViewModel.swift
//  MLModernConcurrency
//
//  Created by M L Ragul on 16/04/25.
//

import Foundation
import Combine

class ConcurrencyViewModel: ObservableObject {
    
    let networkService: NetworkServiceProvider
    private var cancellables = Set<AnyCancellable>()
    @Published var companies = [CompanyModel]()
    
    init(networkService: NetworkServiceProvider) {
        self.networkService = networkService
    }
    
    func fetchDataWithPublisher() {
        self.networkService.fetchCompaniedWithPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in 
                
            }, receiveValue: { [weak self] data in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.companies = data
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchDataWithAsyncAwait() async {
        do {
            let getCompanies = try await self.networkService.fetchCompaniedWithAsyncAwait()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.companies = getCompanies
            }
        } catch {
            print(error)
        }
    }
}
