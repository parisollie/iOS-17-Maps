//
//  Mapas17App.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI

@main
struct Mapas17App: App {
    //V-456,paso 1.9
    @State private var mapa = MapViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
            //Paso 1.10
                .environment(mapa)
        }
    }
}

