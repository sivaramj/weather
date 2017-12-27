//
//  WeatherTestModel.swift
//  WeatherAppTests
//
//  Created by Jebamani, Sivaram on 12/27/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherTestModel: XCTestCase {
    
    let json = "{\"coord\":{\"lon\":-74.01,\"lat\":40.71},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"base\":\"stations\",\"main\":{\"temp\":294.15,\"pressure\":1020,\"humidity\":83,\"temp_min\":293.15,\"temp_max\":295.15},\"visibility\":16093,\"wind\":{\"speed\":2.6,\"deg\":190},\"clouds\":{\"all\":75},\"dt\":1505698080,\"sys\":{\"type\":1,\"id\":2120,\"message\":0.0045,\"country\":\"US\",\"sunrise\":1505731197,\"sunset\":1505775565},\"id\":5128581,\"name\":\"New York\",\"cod\":200}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherModel() {
        if let newData = json.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                let model = WeatherModel(jsonData: json!)
                XCTAssert(model.cityName == "New York", "Failed")
                XCTAssert(model.description == "broken clouds", "Failed")
                XCTAssert(model.iconImage == "04n", "Failed")
                XCTAssert(model.sunrise == 1505731197, "Failed")
                XCTAssert(model.sunset == 1505775565, "Failed")
                
            } catch(_) {
                XCTAssert(false, "Failed to Test Model")
            }
        } else {
            XCTAssert(false, "Failed to Test Model")
        }
    }

}
