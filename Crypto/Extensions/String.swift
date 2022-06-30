//
//  String.swift
//  Crypto
//
//  Created by Fatih Kilit on 11.03.2022.
//

import Foundation

extension String {
    
    var removingHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
