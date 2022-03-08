//
//  DetailView.swift
//  Crypto
//
//  Created by Fatih Kilit on 7.03.2022.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing detai view for \(coin.name)")
    }
    
    var body: some View {
        Text("hello")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
