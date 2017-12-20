//
//  WeatherViewModel.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

class WeatherViewModel: NSObject {
    
    var weatherObjects:[Weather]!
    var groupedDataItems:Dictionary<String, [Weather]>!
    var days:[String] = Array()
    
    override init() {
        
    }
    
    init(weatherObjs:[Weather]) {
        super.init()
        self.weatherObjects = weatherObjs
        self.setUpDataItems()
    }
    
    func numberOfSections()->Int{
        return days.count
    }
    
    func rowsInSection(section:Int)->Int {
        if let dayData = groupedDataItems[days[section]] {
            return dayData.count
        }else{
            return 0
        }
    }
    
    func updateCellWithIndexPath(indexPath:IndexPath, cell:WeatherCell) {
        
        if let dayData = groupedDataItems[days[indexPath.section]] {
            let weather = dayData[indexPath.row]
            cell.weatherDescriptionLabel.text = weather.weatherDescription.capitalized
            cell.temperatureLabel.text = "Temperature: " + "\(weather.temperature!)" + " kelvin"
            cell.pressureLabel.text = "Pressue: " + "\(weather.pressure!)" + " hpa"
            cell.humidityLabel.text = "Humidity: " + "\(weather.humidity!)" + "%"
            cell.windSpeedLabel.text = "Wind Speed: " + "\(weather.windSpeed!)" + " meter/sec"
            
            cell.timeLabel.text = getTimeStampFrom(date: weather.date, withFormat: "h:mm a")
        }
        
    }
    
    func getTimeStampFrom(date:Date, withFormat format:String)->String{
        let dateFormat = format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func setUpDataItems(){
        
        groupedDataItems = Dictionary()
        
        for item in self.weatherObjects {
            let dateStr = getTimeStampFrom(date: item.date, withFormat: "E MMM yyyy")
            
            if !days.contains(dateStr) {
                days.append(dateStr)
            }
            
            if groupedDataItems.keys.contains(dateStr) {
                var weatherItems = groupedDataItems[dateStr]
                weatherItems!.append(item)
                groupedDataItems[dateStr] = weatherItems
            }else{
                groupedDataItems[dateStr] = [item]
            }
            
        }
        
    }
    
}
