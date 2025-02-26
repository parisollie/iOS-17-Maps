//
//  ContentView.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI
import MapKit
struct ContentView: View {
    //Vid 454, con automatico nos da nuestra ubicacion.
    //@State private var cameraPosition: MapCameraPosition = .automatic
    @Environment(MapViewModel.self) var mapModel
    //Vid 457
    @State private var showSearch = true
    
    var body: some View {
        //Vid 456
        @Bindable var mapModel = mapModel
        //Vid 454
        //Vid 459,add selection: $mapModel.markerSelection
        Map(position: $mapModel.cameraPosition, selection: $mapModel.markerSelection){
            //Vid 455, marcadores
            Marker("Mi Ubicacion", systemImage: "house", coordinate: .userLocation)
                .tint(.blue)
            //Vid 458
            ForEach(mapModel.results, id:\.self){ item in
                if mapModel.routeDisplay {
                    //Vid 462, si existe muestrame el destino
                    if item == mapModel.routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.title ?? "", coordinate: placemark.coordinate)
                    }
                }else{
                    //Vid 458
                    let placemark = item.placemark
                    Marker(placemark.title ?? "", coordinate: placemark.coordinate)
                }
                    
            }
            //Vid 462
            if let route = mapModel.route {
                MapPolyline(route.polyline)
                //que tan gruesa queremos la línea
                    .stroke(.blue, lineWidth: 6)
            }
            //Vid 457
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
                mapModel.fetchRoute()
            }
        })
        .onChange(of: mapModel.markerSelection, { oldValue, newValue in
            //Vid 459
            mapModel.showLocation = newValue != nil
        })
        //Vid 457
        .sheet(isPresented: $showSearch, content: {
            SheetSearch(showSearch: $showSearch)
                .interactiveDismissDisabled()
                .presentationDetents([.height(150)])
                .presentationCornerRadius(15)
                .presentationBackground(.ultraThinMaterial)
        })
        //Vid 459
        .sheet(isPresented: $mapModel.showLocation, content: {
            //Vid 462 add  getDirections:
            LocationView(markerSelection: $mapModel.markerSelection, showLocation: $mapModel.showLocation, getDirections: $mapModel.getDirections)
                .presentationDetents([.height(350)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(350)))
                .presentationCornerRadius(15)
                .presentationBackground(.ultraThinMaterial)
        })
        //Vid 456
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

//Vid 454
extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        //Coordenadas de miami
        return .init(latitude: 25.7602, longitude: -80.2369)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}




/*
 //Vid 455,
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
