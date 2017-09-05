//
//  ViewController.swift
//  Sundail
//
//  Created by IK on 26/09/2016.
//  Copyright © 2016 Ikhub. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, URLSessionDelegate,CLLocationManagerDelegate, UITextFieldDelegate {
    let BASEURL  = "https://api.openweathermap.org/data/2.5/forecast/weather?q="
    // let NEWBASEURLPATTERN = https://api.apixu.com/v1/current.json?key=ba3c0ba5f9754cb2909163513170509&q=abuja
    let NEWBASEURL = "https://api.apixu.com/v1/current.json?key=ba3c0ba5f9754cb2909163513170509&q="
    let NEWKEY = "ba3c0ba5f9754cb2909163513170509"
    // let BASEURL  = "https://crossorigin.me/http://api.openweathermap.org/data/2.5/forecast/weather?q="
    // heroCRO appid = bd27ec550c3395c05817ce2f84583b3a
    //https://cors-anywhere.herokuapp.com/
    let KEY = "&appid=bd27ec550c3395c05817ce2f84583b3a"
    let WeatherIconBaseURL = "https://crossorigin.me/http://openweathermap.org/img/w/"
    var latitude = 1.0
    var longitude = 1.0
    var locationManager:CLLocationManager!
    
    
  
    @IBOutlet weak var findCityTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageViewer: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get user location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.findCityTextField.delegate = self
        
        let urlString = "https://crossorigin.me/http://api.openweathermap.org/data/2.5/forecast/weather?q=kano&appid=bd27ec550c3395c05817ce2f84583b3a"
        
        let CurrentLocationUrl: String = ("https://crossorigin.me/http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon= \(longitude)&units=metric&appid=\(KEY)")
        
//        let bibleurl = "https://crossorigin.me/http://labs.bible.org/api/?passage=John%203:19&type=json"

        
      
    }


    func createUrl(_ city: String) -> URL? {
        // let url = BASEURL + city + KEY
            let url = NEWBASEURL + city
        
        guard let nsurl =  URL(string: url) else { return nil }
        return nsurl
        
    }
    
    
    
    func parseResult(_ jsonData: Data?) {
        print("inside the parse result")
        do {
            if let jsonResult = jsonData{
                let result = try JSONSerialization.jsonObject(with: jsonResult, options: []) as? [String: AnyObject]
                let city = result!["location"] as![String: AnyObject]
                let currentWeather = result!["current"] as! [String: AnyObject]
                let currentCondition = currentWeather["condition"] as! [String: AnyObject]
                print("got city")
                let name = city["name"] as! String
                let country = city["country"] as! String
                let location = name + ", " + country
                let temp_f = currentWeather["temp_f"] as! Double
                let temp_c = currentWeather["temp_c"] as! Double
                //let celTemp = Int(self.kelvinToCelcious(temp))
                print(Int(temp_c))
                let weatherDescription = currentCondition["text"] as! String
//                let weatherIcon = currentCondition["icon"] as! String
//                let imageUrl = URL(string: weatherIcon )
//                let data = try? Data(contentsOf: imageUrl!)
//            guard let imageData = data else{ return
//                    //iconImageViewer.image = UIImage(data: imageData)
//                }
                DispatchQueue.main.async(execute: {
                    Void in
                    self.updateView(location, temp: Int(temp_c), description: weatherDescription)
                    // print(weatherDescription + weatherIcon)
                })
               
            }
            
        } catch{
            print("could not parse json")
        }
    } // end of function
    
 
    @IBAction func searchLocationsWeather(_ sender: AnyObject) {
        let searchCity = self.findCityTextField.text!
        if searchCity.characters.count <= 1 {
            return
        }
        print(searchCity)
        let cityNsurl = self.createUrl(searchCity)
        print(cityNsurl as Any)
        guard let theCityNsurl = cityNsurl else { return  }
        var request = URLRequest(url: theCityNsurl)
            // request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (result, respnose, error) in
            self.parseResult(result!)
        });
        task.resume()
        
    }  // END OF FUNCTION
    
    
//    func kelvinToCelcious(_ kelvinTemp: Double) -> Double {
//        return kelvinTemp - 273.15
//    }  // END OF FUNCTION
//    
//    func celciusToFarh(_ celciusTemp: Double) -> Double {
//        return (celciusTemp * 1.8 ) + 32
//    } // END OF FUNCTION
//    
//    func farhToCelcius(_ farhTemp:Double) -> Double {
//        return (farhTemp - 32) / 1.8
//    } // END OF FUNCTION
    

    
    func updateView(_ location: String, temp: Int, description: String) {
        print("updating view")
        self.locationLabel.text = location
        self.tempLabel.text = String(temp) + "ºC"
        // self.iconImageViewer.image = UIImage(data: imageData)
        self.weatherDescriptionLabel.text = description
    }   //end of updateview function
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [ CLLocation ]) {
         let newLocation: CLLocation = locations[ 0 ]
        
         var coordinateDesc: String = "Not Available"
         var altitudeDesc: String = "Not Available"
        
         if newLocation.horizontalAccuracy >= 0 {
             coordinateDesc =
            "\(newLocation.coordinate.latitude ), \(newLocation.coordinate.longitude )"
             coordinateDesc = coordinateDesc +
             " +/- \( newLocation.horizontalAccuracy ) meters"
        }
        
        if newLocation.verticalAccuracy >= 0 {
             altitudeDesc = " \( newLocation.altitude )"
             altitudeDesc = altitudeDesc +
            " +/- \( newLocation.verticalAccuracy ) meters"
             }
        
        
         }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.findCityTextField.resignFirstResponder()
        return true
    }
    
 
}

