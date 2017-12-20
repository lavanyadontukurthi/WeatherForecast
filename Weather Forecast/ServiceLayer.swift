//
//  ServiceLayer.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

fileprivate var appId = "a5f7af40bddd5f2ccc5990e91ca5cd89"

class ServiceLayer: NSObject {
    
    func getWeatherForecast(cityName:String, onCompletion:@escaping (_ weatherObjects:[Weather]?, _ error:Error?)->Void) {
        
        let urlSession = URLSession.shared
        let urlStr = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(appId)"
        
        
        if let str = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            guard let url = URL(string: str) else{
                onCompletion(nil, nil)
                return
            }
            
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                
                if let data = data {
                    let weatherObjects = self.parseWeatherResponse(data: data)
                    onCompletion(weatherObjects, nil)
                }else{
                    onCompletion(nil, error)
                }


            }
            dataTask.resume()
        }else{
            onCompletion(nil, nil)
        }
        
    }
    
    func parseWeatherResponse(data:Data)->[Weather]?{
        var weatherObjects:[Weather]?
        
        
        if let weatherData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject> {
            
            if let weatherData = weatherData, let list = weatherData["list"] as? [Dictionary<String, AnyObject>] {
                
                weatherObjects = Array()
                for item in list {
                    
                    if let weather = Weather(jsonDict: item) {
                        weatherObjects?.append(weather)
                    }
                }
                
                weatherObjects!.sort(by: { $0.date.compare($1.date) == .orderedAscending})
            }
            
        }
        return weatherObjects
    }
    
}
