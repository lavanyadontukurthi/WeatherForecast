//
//  Weather.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

class Weather: NSObject {
    
    var date:Date!
    var temperature:Double!
    var pressure:Double!
    var humidity:Double!
    var weatherDescription:String!
    var windSpeed:Double!
    
    init?(jsonDict:Dictionary<String, AnyObject>) {
        
        guard let dateStr = jsonDict["dt_txt"] as? String,
            let date = dateStr.getDateFromString(),
            let mainDict = jsonDict["main"] as? Dictionary<String, AnyObject>,
            let temperature = mainDict["temp"] as? Double,
            let pressure = mainDict["pressure"] as? Double,
            let humidity = mainDict["humidity"] as? Double,
            let weather = (jsonDict["weather"] as? [Dictionary<String, AnyObject>])?.first,
            let weatherDesc = weather["description"] as? String,
            let wind = jsonDict["wind"] as? Dictionary<String, AnyObject>,
            let windSpeed = wind["speed"] as? Double
            else {
                return nil
        }
        
        self.date = date
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.weatherDescription = weatherDesc
        self.windSpeed = windSpeed
    }
    
    
}

extension String {
    
    func getDateFromString()->Date?{
        let dateFormat = "yyyy-MM-dd HH:ss:zz"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
        
    }
    
}
