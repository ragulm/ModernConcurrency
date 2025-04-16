//
//  PublisherView.swift
//  MLModernConcurrency
//
//  Created by M L Ragul on 16/04/25.
//

import SwiftUI

struct PublisherView: View {
    
    @StateObject var viewModel = ConcurrencyViewModel(networkService: NetworkService())
    
    var body: some View {
        List(viewModel.companies) { data in
            Text(data.name!)
        }
        .onAppear {
            viewModel.fetchDataWithPublisher()
        }
    }
}

#Preview {
    PublisherView()
}
