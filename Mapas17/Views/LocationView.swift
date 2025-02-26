//
//  LocationView.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI
import MapKit
struct LocationView: View {
    //V-459, paso 1.25
    @Binding var markerSelection : MKMapItem?
    @Binding var showLocation : Bool
    //V-460, paso 1.31
    @State private var lookAroundScene: MKLookAroundScene?
    //V-462, paso 1.38
    @Binding var getDirections : Bool
    
    var body: some View {
        VStack{
            //Paso 1.26
            Text(markerSelection?.placemark.name ?? "")
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            //Paso 1.27
            Text(markerSelection?.placemark.title ?? "")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .lineLimit(2)
                .padding(.trailing)
            
            //Paso 1.32
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.all)
            }else{
                //V-462,paso 1.46
                ContentUnavailableView("Sin vista previa", systemImage: "eye.slash")
            }
            //V-462,paso 1.37
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
                    //Paso 1.39
                    getDirections = true
                    showLocation = false
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.circle")
                }.buttonStyle(.borderedProminent)
                    .tint(.green)

            }
            
            
        }.padding(.all)
        //Paso 1.34
            .onAppear{
                fetchAroundPreview()
            }
            .onChange(of: markerSelection) { oldValue, newValue in
                fetchAroundPreview()
            }
    }
}

//Paso 1.33
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

#Preview {
    LocationView(
        markerSelection: .constant(nil),
        showLocation: .constant(true),
        getDirections: .constant(false)
    )
}

