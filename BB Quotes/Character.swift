//
//  Character.swift
//  BB Quotes
//
//  Created by Nuno Mendonça on 03/06/2023.
//

import Foundation

struct Character: Decodable {
    
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let portrayedBy: String
}
