//
//  GalleryPhotoModel.swift
//  PuppyGram
//
//  Created by Carlos Ferreira on 9/2/22.
//

import Foundation
import UIKit

struct HoroscopeModel: Decodable & Hashable {
    
    let sign: String?
    let horoscopes_in_response: Int?
    let payload: [HoroscopePayloadModel]?
    
    init(sign: String?, horoscopes_in_response: Int) {
        self.sign = sign
        self.horoscopes_in_response = horoscopes_in_response
        self.payload = [HoroscopePayloadModel(date: "", horoscope: "")]
    }
}
