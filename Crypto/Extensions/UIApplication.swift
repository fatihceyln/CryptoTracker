//
//  UIApplication.swift
//  Crypto
//
//  Created by Fatih Kilit on 21.02.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
