//
//  GalleryResponse.swift
//  PuppyGram
//
//  Created by Carlos Ferreira on 9/2/22.
//

import Foundation

struct HoroscopePayloadModel: Decodable & Hashable {
    
    let date: String?
    let horoscope: String?
    
    init(date: String, horoscope: String) {
        self.date = date
        self.horoscope = horoscope
    }
    
}

