//
//  MapViewModel.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import Foundation
import Observation
import SwiftUI
import MapKit

//Vid 456 
@Observable
class MapViewModel {
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var search : String = ""
    //Vid 458
    var results = [MKMapItem]()
    //Vid 459
    var markerSelection : MKMapItem?
    var showLocation = false
    //Vid 461
    var getDirections = false
    var routeDisplay = false
    var route : MKRoute?
    var routeDestination : MKMapItem?
    
    //Vid 458
    func searchPlace() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        search = ""
        //vid 462
        getDirections = false
        routeDisplay = false
      
    }
    //Vid 461
    func fetchRoute(){
        if let markerSelection {
            let request = MKDirections.Request()
            //nuestro origen
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = markerSelection
            
            Task{
                //Para que nos calcule la ruta
                let result = try? await MKDirections(request: request).calculate()
                //trae la primera ruta que encuentres
                route = result?.routes.first
                routeDestination = markerSelection
                withAnimation(.snappy){
                    //muestrame la ruta
                    routeDisplay = true
                    showLocation = false
                    //es como un zoom, nos selecciona el camino ,para que no se vea lejos
                    if let rect = route?.polyline.boundingMapRect, routeDisplay {
                        cameraPosition = .rect(rect)
                    }
                }
            }
            
        }
    }
    
    
    
}
