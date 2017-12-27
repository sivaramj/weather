//
//  WebServiceManager.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
import CoreLocation

typealias weatherHandler = (_ object: WeatherModel?, _ error: OWError?) -> Void

class WebServiceManager {
    fileprivate let appId = "a8fe49884364d03a655e1fd715f27797"
    fileprivate let apiUrl = "http://api.openweathermap.org/data/2.5/weather"
    
    /// Private Method used to generate URL based on the city typed by the user
    fileprivate func generateURL(city: String) -> URL? {
        guard var component = URLComponents(string: apiUrl) else {
            return nil
        }
        component.queryItems = [URLQueryItem(name: "q", value: city),
                                URLQueryItem(name: "appid", value: appId)]
        return component.url
    }
    
    /// Private Method used to generate URL based on the user location tracked
    fileprivate func generateURL(location: CLLocation) -> URL? {
        guard var component = URLComponents(string: apiUrl) else {
            return nil
        }
        component.queryItems = [URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
                                URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
                                URLQueryItem(name: "appid", value: appId)]
        return component.url
    }
    
    /// Private Method which performs the Network operation and provide back the appropriate ouput.
    //// Model -> If the json is valid then will parse and send back the Weather model to the viewcontroller
    //// Error -> Provide OWError type where viewcontroller can act on it
    fileprivate func retrieveWeatherURL(url: URL, completionHandler: @escaping weatherHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request,
                                    completionHandler: { data, response, networkError in
                                        if let _ = networkError {
                                            if let code = response as? HTTPURLResponse {
                                                completionHandler(nil, OWError.NetworkFailed(code: code.statusCode, description: networkError.debugDescription))
                                            } else {
                                                completionHandler(nil, OWError.NetworkFailed(code: 400, description: networkError.debugDescription))
                                            }
                                            return
                                        }
                                        
                                        guard let data = data else {
                                            completionHandler(nil, OWError.NetworkFailed(code: 400, description: ""))
                                            return
                                        }
                                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                            let model = WeatherModel(jsonData: json!)
                                            completionHandler(model, nil)
                                        } else {
                                            completionHandler(nil, OWError.InvalidJson(code: 999, description: "Unable to parse Json"))
                                        }
        })
        task.resume()
    }
    
    
    /// Public Method used to generate URL based on the user location tracked
    func getWeatherForLocation(location: CLLocation, completionHandler: @escaping weatherHandler) {
        guard let url = generateURL(location: location) else {
            completionHandler(nil, OWError.InvalidUrl)
            return
        }
        retrieveWeatherURL(url: url, completionHandler: completionHandler)
    }
    
    /// Public Method used to generate URL based on the city typed by the user
    func getWeatherForCity(city: String, completionHandler: @escaping weatherHandler) {
        guard let url = generateURL(city: city) else {
            completionHandler(nil, OWError.InvalidUrl)
            return
        }
        retrieveWeatherURL(url: url, completionHandler: completionHandler)
    }
    
    
    
}
