//
//  Mapas17App.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//

import SwiftUI

@main
struct Mapas17App: App {
    //Vid 456
    @State private var mapa = MapViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mapa)
        }
    }
}

