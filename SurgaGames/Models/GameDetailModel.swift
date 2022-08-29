//
//  GameDetailModel.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 27/05/22.
//

import Foundation


struct GameDetailModel: Decodable {
    let id: Int
    let name: String
    let description_raw: String
    let background_image: String
    let rating: Float
    let genres: [Genres]
}
