//
//  LocationView.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI
import MapKit
struct LocationView: View {
    //Vid 459
    @Binding var markerSelection : MKMapItem?
    @Binding var showLocation : Bool
    //Vid 460
    @State private var lookAroundScene: MKLookAroundScene?
    //Vid 462
    @Binding var getDirections : Bool
    
    var body: some View {
        VStack{
            
            Text(markerSelection?.placemark.name ?? "")
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            Text(markerSelection?.placemark.title ?? "")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .lineLimit(2)
                .padding(.trailing)
            //Vid 460
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.all)
            }else{
                //Vid 462
                ContentUnavailableView("Sin vista previa", systemImage: "eye.slash")
            }
            //Vid 462
            HStack(spacing: 30){
                Button {
                    //si esta true
                    if let markerSelection {
                        //enviamos una seleccion
                        markerSelection.openInMaps()
                    }
                } label: {
                    Image(systemName: "map.circle")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                
                Button {
                    //Vid 462
                    getDirections = true
                    showLocation = false
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.circle")
                }.buttonStyle(.borderedProminent)
                    .tint(.green)

            }
            
            
        }.padding(.all)
        //Vid 460
            .onAppear{
                fetchAroundPreview()
            }
            .onChange(of: markerSelection) { oldValue, newValue in
                fetchAroundPreview()
            }
    }
}

//Vid 460
extension LocationView {
    func fetchAroundPreview(){
        if let markerSelection {
            lookAroundScene = nil
            Task{
                let request = MKLookAroundSceneRequest(mapItem: markerSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

