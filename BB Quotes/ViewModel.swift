//
//  ViewModel.swift
//  BB Quotes
//
//  Created by Nuno Mendonça on 04/06/2023.
//

import Foundation

// Class: Mais flexivel. Multiple properties to point at the same class.
// Struct everything is set the way you do it initally. Não vamos mudar muito a data.
// View Model also needs to be on the main thread because it works so closely with the MainView

//ObservableObject: Something that can be observed by other things (tipo a view). To watch for published properties so the view updates.
@MainActor // - Has to run on the main thread because it's so tied to the view that it can make it slow.
class ViewModel: ObservableObject {
    
    enum Status {
        
        case notStarted
        case fetching
        case success(data: (quote: Quote, character: Character))
        case failed(error: Error)
    }
    
    //Property that we want the view to be able to observe
    // Only the set is private. Everyone else can see it.
    @Published private(set) var status: Status = .notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {

        self.controller = controller
    }
    
    func getData(for show: String) async {

        status = .fetching
        
        //Since there can be throws:
        do {
            
            let quote = try await controller.fetchQuote(from: show)
            
            let character = try await controller.fetchCharacter(quote.character)
            
            status = .success(data: (quote, character))
            
        } catch {
            status = .failed(error: error)
        }
    }
}
