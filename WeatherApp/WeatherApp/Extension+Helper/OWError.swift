//
//  OWError.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
enum OWError: Error {
    case InvalidUrl
    case NetworkFailed(code: Int, description: String)
    case InvalidJson(code: Int, description: String)
}
