//
//  GameResponse.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import Foundation

struct GameResponse: Decodable{
    
    let results: [Game]
    
    struct Game: Decodable {
        let id: Int64
        let name: String
        let released: String
        let background_image: String
        let rating: Float
        let genres: [Genres]
    }
    
}
