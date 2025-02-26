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

//V-456 ,paso 1.8 creamos el MapViewModel
@Observable
class MapViewModel {
    //Ponemos nuestras variables.
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var search : String = ""
    //V-458,paso 1.19
    var results = [MKMapItem]()
    //V-459, paso 1.24
    var markerSelection : MKMapItem?
    var showLocation = false
    //V-461, Paso 1.35, linea para el mapa
    var getDirections = false
    var routeDisplay = false
    var route : MKRoute?
    var routeDestination : MKMapItem?
    
    //Paso 1.20
    func searchPlace() async {
        let request = MKLocalSearch.Request()
        //Para que nos entienda al momento de escribir
        request.naturalLanguageQuery = search
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        search = ""
        //V-462,paso 1.45, para seguir haciendo mas busquedas.
        getDirections = false
        routeDisplay = false
      
    }
    //Paso 1.36
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
