//
//  AQITableViewModel.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

import UIKit

class AQITableViewModel: AQBaseViewModel {
    
    func numberOfRows(inSection section: Int) -> Int {
        return defaultCitiesList.count
    }
}

class AQIGraphViewModel: AQBaseViewModel {
    
    override func handleUpdate() {
        if let filteredList = filtered(cities: citiesList, from: pollList), !filteredList.isEmpty {
            mergeIntoDefaultList(filteredList)
            delegate?.viewModelDidUpdate()
        }
    }
}
