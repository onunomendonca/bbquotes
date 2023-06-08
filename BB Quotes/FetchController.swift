//
//  FetchController.swift
//  BB Quotes
//
//  Created by Nuno Mendonça on 03/06/2023.
//

import Foundation

struct FetchController {
    
    enum NetworkError: Error {
        
        case badURL, badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    // Async - runs in the background we always have to use:
    // Await - while you are awaiting for this, do something else in the BG
    // Try - Try to run this, but an error might be thrown_
    // Throws - isto pode falhar, portanto cuidado
    func fetchQuote(from show: String) async throws -> Quote {
        
        let quoteURL = baseURL.appending(path: "quote/random")
        var quoteComponents = URLComponents(url: quoteURL, resolvingAgainstBaseURL: true)
        let quoteQueryItem = URLQueryItem(name: "production", value: show.replaceSpaceWithPlus)
        quoteComponents?.queryItems = [quoteQueryItem]
        
        guard let fetchURL = quoteComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {

            throw NetworkError.badResponse
        }
        
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Character {
        
        let characterURL = baseURL.appending(path: "characters")
        var characterComponents = URLComponents(url: characterURL, resolvingAgainstBaseURL: true)
        let characterQueryItem = URLQueryItem(name: "name", value: name.replaceSpaceWithPlus)
        characterComponents?.queryItems = [characterQueryItem]
        
        guard let fetchURL = characterComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            
            throw NetworkError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // There can be more than one Walter.
        let characters = try decoder.decode([Character].self, from: data)
        
        return characters[0]
    }
}
