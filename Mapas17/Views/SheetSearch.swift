//
//  SheetSearch.swift
//  Mapas17
//
//  Created by Paul F on 07/10/24.
//


import SwiftUI

//Vid 457
struct SheetSearch: View {
    
    @Environment(MapViewModel.self) var mapModel
    @Binding var showSearch : Bool
    
    var body: some View {
        @Bindable var mapModel = mapModel
        NavigationStack{
            VStack{
                TextField("Buscar..", text: $mapModel.search)
                    .padding(12)
                    .background(.gray.opacity(0.1))
                    .presentationCornerRadius(6)
                    .foregroundStyle(.primary)
                
            }
            //Vid 458,usa el enter del teclado
            .onSubmit {
                //cuando usamos funcion asincrona usamos task
                Task{
                    await mapModel.searchPlace()
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

