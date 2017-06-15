//
//  DarkSkyWeatherService.swift
//  GeoCalculator
//
//  Created by user127998 on 6/13/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import Foundation
import Foundation

let sharedDarkSkyInstance = DarkSkyWeatherService()

class DarkSkyWeatherService: WeatherService {
    
    let API_BASE = "https://api.darksky.net/forecast/"
    var urlSession = URLSession.shared
    
    class func getInstance() -> DarkSkyWeatherService {
        return sharedDarkSkyInstance
    }
    
    func getWeatherForDate(date: Date, forLocation location: (Double, Double),
                           completion: @escaping (Weather?) -> Void)
    {
        
        let urlStr = API_BASE + "7f3173cabdddf922996c78147dde3c55" + String(location.0) + "," + String(location.1)
        let url = URL(string: urlStr)
        
        let task = self.urlSession.dataTask(with: url!) {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let _ = response {
                let parsedObj : Dictionary<String,AnyObject>!
                do {
                    parsedObj = try JSONSerialization.jsonObject(with: data!,
                                                                 options:
                        .allowFragments) as? Dictionary<String,AnyObject>
                    
                    guard let currently = parsedObj["currently"],
                        let temperature = currently["temperature"] as? Double,
                        let icon = currently["icon"] as? String,
                        let summary = currently["summary"] as? String
                    
                    else {
                        completion(nil)
                        return
                    }

                    let weather = Weather(iconName: icon, temperature:
                        temperature,
                                          summary: summary)
                    completion(weather)
                    
                } catch {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
}
