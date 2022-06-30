//
//  ChartCoinRowView.swift
//  Crypto
//
//  Created by Fatih Kilit on 13.03.2022.
//

import SwiftUI

struct ChartCoinRowView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    @State private var percentage: CGFloat = 1
    private var coin: Coin
    
    private var cacheManager = CacheManager.shared
    
    init(coin: Coin) {
        self.coin = coin
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        lineColor = priceChange >= 0 ? .theme.green: .theme.red
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    
                    for index in data.indices {
                        
                        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        
                        let yAxis = maxY - minY
                        let yPosition = (1 - CGFloat((data[index] - minY)) / yAxis) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 5)
                .shadow(color: lineColor.opacity(0.25), radius: 10, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.125), radius: 10, x: 0, y: 20)
            }
        }
        .frame(width: 90, height: 50)
        .onAppear {
            getChart()
        }
    }
    
    private func getChart() {
        
        // if user sees the coin for first time _ will be nil, if it's nil it'll enter else block if it's not it'll do nothing.
        
        guard let _ = cacheManager.getChart(id: coin.id) else {
            // first time user will see chart
    
            percentage = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 0.5)) {
                    percentage = 1
                    cacheManager.addChart(id: coin.id, userSaw: true)
                }
            }
    
            return
        }
    }
}

struct ChartCoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChartCoinRowView(coin: dev.coin)
    }
}
