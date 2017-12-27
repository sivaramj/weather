//
//  UIImageView+Weather.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
extension UIImageView {
    
    /// Helper method to fetch the image from server asyncronously and loads it on UI if ready
    func imageFromUrl(urlString: String, callback: ((_ wasAbleToLoadImage: Bool)->Void)? = nil) {
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // fetch this image from the server
        let session = URLSession.shared
        let request = URLRequest(url: url as URL)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error:Error?) -> Void in
            
            // Read the http status code in the http response
            guard let imageData = data as Data?,
                let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode == 200
                else {
                    // No image was fetched from server
                    callback?(false)
                    return
            }
            //  Received image from server
            
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
                callback?(true)
            }
        })
        
        task.resume()
    }
}
