//
//  GalleryViewModel.swift
//  PuppyGram
//
//  Created by Carlos Ferreira on 9/2/22.
//

import Foundation
import UIKit
import SwiftUI

class HoroscopeViewModel: ObservableObject {
    
    let url = "https://staging.sanctuaryappbackend.com/content/api/horoscope/"
    let key = "7YsRTZcovUUppyFJ1s6QEUsR2i9Djw3jvHAZEEMEXJUJfs1zAb3swvc01KlNs1wc"
    
    @Published public var horoscopes = [HoroscopeModel]()
    
    init() {
        reload(period: .Daily)
    }
    
    public func reload(period: Period) {
        DispatchQueue.global(qos: .background).async {
            self.loadHoroscope(period: period)
        }
    }
    
    public func loadHoroscope(period: Period) {
        var urlRequest = URLRequest(url: URL(string: url + period.rawValue)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(key, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            if case 200 ..< 300 = httpResponse.statusCode {
                do {
                    let jsonDecoder = JSONDecoder()
                    let horoscopes = try jsonDecoder.decode([HoroscopeModel].self, from: data!)
//                    print("horoscopes: \(horoscopes)")
                    DispatchQueue.main.async {
                        self?.horoscopes = horoscopes
                    }
                    

                } catch {
                    print(error)
                }

            }
        }
        .resume()
    }
                                    
    public enum Period: String {
        case Daily = "daily"
        case Monthly = "monthly"
    }
}


