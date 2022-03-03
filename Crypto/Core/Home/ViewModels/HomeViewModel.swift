//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Fatih Kilit on 15.02.2022.
//

import Foundation
import Combine

/*
 class HomeViewModel: ObservableObject {
 @Published var allCoins: [Coin]
 @Published var portfolioCoins: [Coin]
 @Published var searchText: String
 @Published var statistics: [Statistic]
 
 private let coinDataService: CoinDataService
 private let marketDataService: MarketDataService
 private let portfolioDataService: PortfolioDataService
 private var cancellables: Set<AnyCancellable>
 
 private func addSubscribers()
 
 func updatePortfolio(coin: Coin, amount: Double)
 
 private func filterCoins(text: String, coins: [Coin]) -> [Coin]
 
 private func mapGlobaleMarketData(marketData: MarketData?) -> [Statistic]
 
 }
 */

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    @Published var statistics: [Statistic] = []
    
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        // no more need for this.
        /*
         dataService.$allCoins
         .sink { [weak self] coins in
         self?.allCoins = coins
         }
         .store(in: &cancellables)
         */
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main, options: nil)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map (mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink(receiveValue: { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.contains(lowercasedText)
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntites: [PortfolioEntity]) -> [Coin] {
        allCoins.compactMap { coin -> Coin? in
            guard let entity = portfolioEntites.first(where: {$0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume, percentageChange: nil)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance, percentageChange: nil)
        
        let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}
