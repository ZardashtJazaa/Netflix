//
//  APIError.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import Foundation

enum ApiError:LocalizedError {
    
    case failedToGetData
    case requestError
    case decodingData
    
    var errorDescription: String {
        switch self {
        case .failedToGetData:
            return "Failed to get data from Api!.."
            
        case .requestError:
            return "Unable to Request to API!.."
            
        case .decodingData:
            return "Unable to Decode the Data!.."
        }
    }
}


