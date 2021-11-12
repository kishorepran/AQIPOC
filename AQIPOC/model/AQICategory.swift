//
//  AQICategory.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

import UIKit

enum AQICategory: Int {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe

    init?(rawValue: Int) {
        switch rawValue {
        case 0 ... 50: self = .good
        case 51 ... 100: self = .satisfactory
        case 101 ... 200: self = .moderate
        case 201 ... 300: self = .poor
        case 301 ... 400: self = .veryPoor
        case 401 ... 500: self = .severe
        default: return nil
        }
    }

}

extension AQICategory {
    
    var displayString: String {
        switch self {
        case .good : return "Good"
        case .satisfactory : return "Satisfcatory"
        case .moderate : return "Moderate"
        case .poor : return "Poor"
        case .veryPoor : return "VeryPoor"
        case .severe : return "Severe"
        }
    }

    var color: UIColor {
        switch self {
        case .good:
            return UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        case .satisfactory:
            return UIColor(red: 148.0/255.0, green: 192.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .moderate:
            return UIColor(red: 254.0/255.0, green: 250.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        case .poor:
            return UIColor(red: 236.0/255.0, green: 138.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        case .veryPoor:
            return UIColor(red: 225.0/255.0, green: 40.0/2550.0, blue: 39.0/255.0, alpha: 1.0)
        case .severe:
            return UIColor(red: 157.0/255.0, green: 28.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
}
