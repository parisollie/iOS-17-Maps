//
//  ContentView.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI
import MapKit
struct ContentView: View {
    /*Paso 1.2, con automatic nos da nuestra ubicacion.
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)*/
    //V-456 Paso 1.11
    @Environment(MapViewModel.self) var mapModel
    
    //V-457,Paso 1.15
    @State private var showSearch = true
    
    var body: some View {
        //Paso 1.12
        @Bindable var mapModel = mapModel
        /*
         Paso 1.3
         Paso 1.13, ponemos $mapModel.cameraPosition
         Vid 459,paso 1.28 add selection: $mapModel.markerSelection
         */
        Map(position: $mapModel.cameraPosition, selection: $mapModel.markerSelection){
            //V-455,Paso 1.5 marcadores
           Marker("Mi Ubicacion", systemImage: "house", coordinate: .userLocation)
                .tint(.blue)
            
            //V-458,Paso 1.22
            ForEach(mapModel.results, id:\.self){ item in
                //Paso 1.42
                if mapModel.routeDisplay {
                    //Paso 1.43, si existe muestrame el destino
                    if item == mapModel.routeDestination {
                        //Paso 1.23
                        let placemark = item.placemark
                        Marker(placemark.title ?? "", coordinate: placemark.coordinate)
                    }
                }else{
                    let placemark = item.placemark
                    Marker(placemark.title ?? "", coordinate: placemark.coordinate)
                }
                    
            }
            //V-462,paso 1.40
            if let route = mapModel.route {
                MapPolyline(route.polyline)
                //que tan gruesa queremos la línea
                    .stroke(.blue, lineWidth: 6)
            }
            //Paso 1.18
        }.overlay(alignment: .topLeading){
            VStack{
                Button {
                    //Vid 459
                    mapModel.showLocation = false
                    showSearch = true
                    
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.largeTitle)
                }

            }.padding(.leading, 15)
        }
        //Vid 462
        .onChange(of: mapModel.getDirections, { oldValue, newValue in
            if newValue {
                //Paso 1.41
                mapModel.fetchRoute()
            }
        })
        //paso 1.30
        .onChange(of: mapModel.markerSelection, { oldValue, newValue in
            //En caso de elegir varios y seleccionar varios
            mapModel.showLocation = newValue != nil
        })
        //Paso 1.17
        .sheet(isPresented: $showSearch, content: {
            SheetSearch(showSearch: $showSearch)
                .interactiveDismissDisabled()
                .presentationDetents([.height(150)])
                .presentationCornerRadius(15)
                .presentationBackground(.ultraThinMaterial)
        })
        //Paso 1.29
        .sheet(isPresented: $mapModel.showLocation, content: {
            //Paso 1.44 add  getDirections:
            LocationView(markerSelection: $mapModel.markerSelection, showLocation: $mapModel.showLocation, getDirections: $mapModel.getDirections)
                .presentationDetents([.height(350)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(350)))
                .presentationCornerRadius(15)
                .presentationBackground(.ultraThinMaterial)
        })
        //V-456 Paso 1.7
        .mapControls{
            //Brujúla
            MapCompass()
            //agrega el boton para cambiar en 2d y 3d
            MapPitchToggle()
            //nos pone en la posicion original
            MapUserLocationButton()
        }
    }
}

//V-454,Paso 1.0
extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        //Coordenadas de miami
        return .init(latitude: 25.7602, longitude: -80.2369)
    }
}
//Paso 1.1
extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}


/*
 //Vid 455,Paso 1.6
 Annotation("Mi Ubicacion", coordinate: .userLocation) {
     ZStack{
         Circle()
             .stroke(Color.red, lineWidth: 10)
             .background(Circle().fill(Color.clear))
             .frame(width: 100, height: 100)
             .overlay{
                 Image(systemName: "house.fill")
                     .font(.system(size: 40))
                     .foregroundStyle(.blue)
             }
     }
 }
 */


#Preview {
    ContentView()
        .environment(MapViewModel())
}
