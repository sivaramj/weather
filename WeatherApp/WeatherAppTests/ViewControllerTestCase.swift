//
//  ViewControllerTestCase.swift
//  WeatherAppTests
//
//  Created by Jebamani, Sivaram on 12/27/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ViewControllerTestCase: XCTestCase {
    var vc: ViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            XCTAssert(false, "Main Storyboard doesn't have identifier ViewController")
            return
        }
        self.vc = vc
        self.vc?.loadView()
        self.vc?.viewDidLoad()
        self.vc?.viewWillAppear(true)
        
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testIBoutlets(){
        guard let outlets = self.vc else {
            XCTAssert(false, "outlets is nil")
            return
        }
        
        XCTAssertNotNil(outlets.btnCelcius, "btnCelcius is not present")
        XCTAssertNotNil(outlets.btnFarenheit, "btnFarenheit is not present")
        XCTAssertNotNil(outlets.btnSearchCity, "btnSearchCity label is not present")
        XCTAssertNotNil(outlets.lblCity, "lblCity is not present")
        XCTAssertNotNil(outlets.lblDegree, "lblDegree is not present")
        XCTAssertNotNil(outlets.lblDescription, "lblDescription is not present")
        XCTAssertNotNil(outlets.lblSunset, "lblSunset is not present")
        XCTAssertNotNil(outlets.lblSunrise, "lblSunrise is not present")
        XCTAssertNotNil(outlets.imgWeather, "imgWeather is not present")
        XCTAssertNotNil(outlets.imgBackground, "imgBackground is not present")
    }
    
}
