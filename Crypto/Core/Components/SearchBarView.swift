//
//  SearchBarView.swift
//  Crypto
//
//  Created by Fatih Kilit on 21.02.2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText :
                        Color.theme.accent
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .disableAutocorrection(true)
                .foregroundColor(Color.theme.accent)
                
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .trailing)
                .foregroundColor(.theme.accent)
                .padding(10)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    searchText = ""
                    UIApplication.shared.endEditing()
                }
                
        }
        .font(.headline)
        .frame(height: 30)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(color: Color
                            .theme
                            .accent
                            .opacity(searchText.isEmpty ? 0.2 : 0.4),
                        radius: 10)
        )
        .padding()
        .animation(Animation.easeInOut, value: searchText)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            
    }
}
