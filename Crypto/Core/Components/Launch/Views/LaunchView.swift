//
//  LaunchView.swift
//  Crypto
//
//  Created by Fatih Kilit on 11.03.2022.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading Your Portfolio...".map({String($0)})
    @State private var showLoadingText: Bool = false
    
    private let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    @State private var counter: Int = -1
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    /*
                     Text(loadingText)
                     .font(.headline)
                     .fontWeight(.heavy)
                     .foregroundColor(Color.launch.accent)
                     .transition(AnyTransition.scale.animation(.easeIn))
                     */
                    
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    counter += 1
                    if counter == loadingText.count {
                        counter = 0
                        loops += 1
                        
                        if loops >= 2 {
                            showLaunchView = false
                        }
                    }
                }
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
