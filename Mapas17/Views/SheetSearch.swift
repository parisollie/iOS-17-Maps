//
//  SheetSearch.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//


import SwiftUI

//V-457,paso 1.14
struct SheetSearch: View {
    
    @Environment(MapViewModel.self) var mapModel
    @Binding var showSearch : Bool
    
    var body: some View {
        //paso 1.16, ponemos el Bindable
        @Bindable var mapModel = mapModel
        NavigationStack{
            VStack{
                TextField("Buscar..", text: $mapModel.search)
                    .padding(12)
                    .background(.gray.opacity(0.1))
                    .presentationCornerRadius(6)
                    .foregroundStyle(.primary)
                
            }
            //V-458,Paso 1.21,usa el enter del teclado
            .onSubmit {
                //cuando usamos funcion asincrona usamos task
                Task{
                    await mapModel.searchPlace()
                    //despues de que se ejecuta que se esconda
                    showSearch = false
                }
            }
            .padding(.all)
            .navigationTitle("Buscar lugar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SheetSearch(showSearch: .constant(true))
        .environment(MapViewModel())
}

