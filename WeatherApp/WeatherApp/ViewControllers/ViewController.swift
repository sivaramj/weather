//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
protocol SearchDelegate:class {
    func updateWeatherUI(searchCity: String)
}
class ViewController: UIViewController {
    
    @IBOutlet weak var btnSearchCity: UIButton!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var btnCelcius: UIButton!
    @IBOutlet weak var btnFarenheit: UIButton!
    
    @IBOutlet weak var imgBackground: UIImageView!
    fileprivate let locationManager = CLLocationManager()
    
    var toggleCelcius: Bool = true {
        didSet{
            self.btnCelcius.isEnabled = !toggleCelcius
            self.btnFarenheit.isEnabled = toggleCelcius
        }
    }
    
    var temperature: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toggleCelcius = true
        
        btnSearchCity.layer.cornerRadius = 10
        //Invoke Location service for initial load
        //  If user has choosen any cities previous load the weather for same
        if let city = UserDefaults.standard.value(forKey: constant.lastSearchedCityKey) as? String {
            self.updateWeather(city: city)
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionCelcius(_ sender: Any) {
        toggleCelcius = true
        self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToCelsius())))º"
    }
    
    @IBAction func actionFarenheit(_ sender: Any) {
        toggleCelcius = false
        self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToFahrenheit())))º"
    }
    
    @IBAction func actionSearchView(_ sender: Any) {
        let searchVC = SearchTableViewController()
        searchVC.delegate = self
        self.present(searchVC, animated: true, completion: nil)
    }
}


// MARK: - CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationDidUpdate(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        /// Fail over load with New york weather
        self.updateWeather(city: constant.defaultLocation)
    }
}


extension ViewController: SearchDelegate {
    func updateWeatherUI(searchCity: String) {
        UserDefaults.standard.set(searchCity, forKey: constant.lastSearchedCityKey)
        UserDefaults.standard.synchronize()
        self.updateWeather(city: searchCity)
    }
}

