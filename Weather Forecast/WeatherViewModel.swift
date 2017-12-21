//
//  WeatherViewModel.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

protocol WeatherViewModelProtocol: NSObjectProtocol {
    func weatherForecastFetchSucceded()
    func weatherForecastFetchFailed(errorDescription:String)
}

protocol CellRepresentable {
    func cellInstance(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell
}

extension Date {
    func getTimeStampwithFormat(_ format:String)->String{
        let dateFormat = format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}

class WeatherViewModel: NSObject, CellRepresentable {
    
    var weatherObjects:[Weather]!
    var groupedDataItems:Dictionary<String, [Weather]>!
    var days:[String] = Array()
    weak var weatherViewModelProtocol:WeatherViewModelProtocol?
    
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
    
    
    func cellInstance(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        cell.selectionStyle = .none
        if let dayData = groupedDataItems[days[indexPath.section]] {
            let weather = dayData[indexPath.row]
            cell.updateCellWith(weather)
        }else{
            cell.clearData()
        }
        
        return cell
    }
    
    func setUpDataItems(){
        groupedDataItems = nil
        days.removeAll()
        
        groupedDataItems = Dictionary()
        
        for item in self.weatherObjects {
            let dateStr = item.date.getTimeStampwithFormat("E MMM yyyy")
            
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

extension WeatherViewModel {
    
    func getWeatherForecast(searchStr:String){
        
        let serviceLayer = ServiceLayer()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        serviceLayer.getWeatherForecast(cityName: searchStr) { [unowned self] (weatherObjs, error) in
            if let weatherObjs = weatherObjs {
                self.weatherObjects = weatherObjs
                self.setUpDataItems()
                DispatchQueue.main.async {
                    if let weatherViewModelProtocol = self.weatherViewModelProtocol {
                        weatherViewModelProtocol.weatherForecastFetchSucceded()
                    }
                }
            }else if error != nil {
                if let weatherViewModelProtocol = self.weatherViewModelProtocol {
                    weatherViewModelProtocol.weatherForecastFetchFailed(errorDescription: error?.localizedDescription ?? "")
                }
                
            }else{
                if let weatherViewModelProtocol = self.weatherViewModelProtocol {
                    weatherViewModelProtocol.weatherForecastFetchFailed(errorDescription: "Unable to fetch results for provided location.")
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
    }
    
}
