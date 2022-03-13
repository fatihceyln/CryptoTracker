//
//  SettingsView.swift
//  Crypto
//
//  Created by Fatih Kilit on 11.03.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var showView: Bool
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/SwiftfulThinking")!
    let coffeULR = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://coingecko.com")!
    let personalURL = URL(string: "https://github.com/fatihceyln")!
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color.theme.background.ignoresSafeArea()
                
                // content
                List {
                    swiftfulThinkingSection
                        .listRowBackground(Color.theme.background)
                    coingeckoSection
                        .listRowBackground(Color.theme.background)
                    developerSection
                        .listRowBackground(Color.theme.background)
                    applicationSection
                        .listRowBackground(Color.theme.background)
                }
            }
            .font(.headline)
            .tint(.blue)
            .navigationTitle("Setting ⚙️")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(showView: $showView)
                }
            }
        }
    }
}

extension SettingsView {
    
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                
                Text("This app was made by fallowing a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine and Core Data")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on YouTube 🥳", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeULR)
        } header: {
            Text("Switful Thinking")
        }
    }
    
    private var coingeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(10)
                
                Text("The cryptocurrency data that is used in this app comes from a free api from CoinGecko! Price may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko 🦎", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(10)
                
                Text("This app was developed by Fatih Kilit. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit Website 🤩", destination: personalURL)
        } header: {
            Text("developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of services", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showView: .constant(true))
    }
}
