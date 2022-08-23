//
//  Extentions.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import Foundation

extension String {
    
    func capitalizedFirstLetter() -> String {
        
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
