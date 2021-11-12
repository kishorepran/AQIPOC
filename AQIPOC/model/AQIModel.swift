//
//  AQIModel.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//
import UIKit

struct Constant {
    // City list we will be capturing data for, for all other cities we will droppping data.
    static let fullCityList = ["Bengaluru", "Delhi", "Mumbai", "Kolkata", "Chennai", "Hyderabad", "Pune"]
}

// MARK: - AQIElement
struct AQIElement: Codable {
    let city: String
    let aqi: Double

    enum CodingKeys: String, CodingKey {
        case city
        case aqi
    }
    // Capture the time stamp when we caught the data point
    let updated = Date()
}

typealias AQIList = [AQIElement]

extension AQIElement: Equatable {
    static func == (lhs: AQIElement, rhs: AQIElement) -> Bool {
        return lhs.city == rhs.city
    }
}
extension AQIElement: Comparable {
    static func < (lhs: AQIElement, rhs: AQIElement) -> Bool {
        return lhs.city < rhs.city
    }
}

extension AQIElement: AQITableCellViewModel {
    var cityName: String {
        return city
    }
    
    var aqiValue: String {
        return String(format: "%.2f", aqi)
    }
    
    var updatedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: updated, relativeTo: Date())
    }
    
    var aqiColor: UIColor? {
        let quality = AQICategory(rawValue: Int(aqi))
        return quality?.color
    }
}


class AQIHistoryCollector {
    private var aqiList: AQIList = []
    
    func addHistory(_ list: AQIList) {
        aqiList.append(contentsOf: list)
        let totalCount = 1000 + list.count
        
        //Do not keep storing unecessary data into array
        if aqiList.count > totalCount {
            aqiList.dropFirst(list.count)
        }
    }
    
    func aqiList(for city: String) -> AQIList {
        let filtered = aqiList.filter {$0.city == city}
        return filtered
    }
}
