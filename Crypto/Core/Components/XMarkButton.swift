//
//  XMarkButton.swift
//  Crypto
//
//  Created by Fatih Kilit on 22.02.2022.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var showView: Bool
    
    var body: some View {
        Button {
            showView = false
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.headline)
        }

    }
}
