//
//  Color.swift
//  Crypto
//
//  Created by Fatih Kilit on 15.02.2022.
//

import Foundation
import SwiftUI

// Color is a struct
extension Color {
    
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
}
