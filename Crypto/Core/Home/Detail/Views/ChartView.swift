//
//  ChartView.swift
//  Crypto
//
//  Created by Fatih Kilit on 11.03.2022.
//

import SwiftUI

struct ChartView: View {
    
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        lineColor = priceChange >= 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = Date(timeInterval: 60 * 60 * 24 * 7 * (-1), since: endingDate)
        //startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    
    // 60,000 max
    // 50,000 min
    // 60,000 - 50,000 = 10,000 -> yAxis
    // 52,000 -> data point
    // 52,000 - 50,000 = 2,000 / 10,000 = 20%
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(alignment: .leading) {
                    chartYAxis
                        .padding(.horizontal, 4)
                }
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)) {
                    percentage = 1
                }
            }
        }
    }
}


extension ChartView {
    private var chartView: some View {
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
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}
