//
//  OtherViewController.swift
//  project1-2
//
//  Created by Hunter Bowman on 4/21/20.
//  Copyright © 2020 Hunter Bowman. All rights reserved.
//

import UIKit
import MapKit

class AboutViewController: UIViewController {
    
    var coords: CLLocationCoordinate2D?
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapType: UISegmentedControl!
    
    @IBOutlet weak var lattitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeMap(_ sender: Any) {
        
        switch(mapType.selectedSegmentIndex)
        {
        case 0:
            map.mapType = MKMapType.standard
        
        case 1:
            map.mapType = MKMapType.satellite
        
        case 2:
            map.mapType = MKMapType.hybrid
            
        default:
            map.mapType = MKMapType.standard
        }
        

    }
    
    @IBAction func searchButton(_ sender: Any) {
        //print("searchButton Pressed")
        search()
    }
    
    
    
    func search() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.searchTextField.text //"pizza"
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response
                else {
                return
            }
            
            //print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            
            for i in 1...matchingItems.count - 1 {
                
                let place = matchingItems[i].placemark
                //print(place.location?.coordinate.latitude)
                //print(place.location?.coordinate.longitude)
                //print(place.name)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = place.location!.coordinate
                annotation.title = place.name
                self.map.addAnnotation(annotation)
            }
        }
        
    }
    
    func showMap(searchItem: String) {
        
        // display the map
        let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: coords!, span: span)
        
        self.map.setRegion(region, animated: true)
        
        // add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords!
        annotation.title = searchItem
        //annotation.subtitle = "AZ"
        
        self.map.addAnnotation(annotation)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let textField = UITextField(frame: CGRect(x: 20.0, y:90.0, width: 280.0, height: 44.0))
        
        //searchTextField.delegate = self
        //searchTextField.returnKeyType = .done
        //searchTextField.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ searchTextField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
       
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
