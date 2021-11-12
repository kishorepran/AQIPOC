//
//  AQITableViewCell.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

import UIKit

protocol AQITableCellViewModel {
    var cityName: String {get}
    var aqiValue: String {get}
    var updatedText: String {get}
    var aqiColor: UIColor? {get}
}

class AQITableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblAQIValue: UILabel!
    @IBOutlet weak var lblLastUpdated: UILabel!

    func configurView(with model: AQITableCellViewModel) {
        lblCityName.text = model.cityName
        lblAQIValue.text = model.aqiValue
        lblLastUpdated.text = model.updatedText
        lblAQIValue.textColor = model.aqiColor
    }
}
