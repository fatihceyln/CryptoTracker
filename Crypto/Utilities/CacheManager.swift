//
//  CacheManager.swift
//  Crypto
//
//  Created by Fatih Kilit on 13.03.2022.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    var chartCache: NSCache<NSString, NSNumber> = {
        let cache = NSCache<NSString, NSNumber>()
        cache.countLimit = 300
        cache.totalCostLimit = 1024 * 1024 * 50
        
        return cache
    }()
    
    func addChart(id: String, userSaw: Bool) {
        chartCache.setObject(NSNumber(value: userSaw), forKey: id as NSString)
    }
    
    func getChart(id: String) -> Bool? {
        return chartCache.object(forKey: id as NSString) as? Bool
    }
}
