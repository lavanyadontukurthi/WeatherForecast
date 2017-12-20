//
//  WeatherCell.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var temperatureLabel:UILabel!
    @IBOutlet weak var pressureLabel:UILabel!
    @IBOutlet weak var humidityLabel:UILabel!
    @IBOutlet weak var weatherDescriptionLabel:UILabel!
    @IBOutlet weak var windSpeedLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func clearData(){
        
        self.weatherDescriptionLabel.text = ""
        self.temperatureLabel.text = ""
        self.pressureLabel.text = ""
        self.humidityLabel.text = ""
        self.windSpeedLabel.text = ""
        
        self.timeLabel.text = ""
        
    }
    
}
