//
//  YoutubeSearchResult.swift
//  Netflix
//
//  Created by Zardasht on 8/20/22.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    
    let items: [VideoElemet]
    
}

struct VideoElemet:Decodable {
    
    let id: idVideoElement
}

struct idVideoElement: Decodable {
    
    let kind: String
    let videoId: String
}
