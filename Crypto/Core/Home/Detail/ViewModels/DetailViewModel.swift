//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Fatih Kilit on 8.03.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { returnedCoinDetails in
                print("RECEIVED COIN DETAIL DATA")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
