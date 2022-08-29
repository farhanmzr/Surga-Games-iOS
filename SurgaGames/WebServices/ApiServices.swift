//
//  ApiServices.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import Foundation

struct ApiService {
    
    func getGames(completion: @escaping (Result<[GameResponse.Game], Error>) -> Void){
        
        let apiKey = "a500402289e74bb48e3ca1a8c4231781"
        guard let url = URL(string: "https://api.rawg.io/api/games?&key=\(apiKey)") else {fatalError("Invalid URL")}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {return}
            print(data)
            do {
                let decoder = JSONDecoder()
                let gameResponse = try decoder.decode(GameResponse.self, from: data)
                completion(.success(gameResponse.results))
                
                print(gameResponse as Any)
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func getDetailGames(id: Int, completion: @escaping (Result<GameDetailModel, Error>) -> Void){
        
        let apiKey = "a500402289e74bb48e3ca1a8c4231781"
        guard let url = URL(string: "https://api.rawg.io/api/games/\(id)?&key=\(apiKey)") else {fatalError("Invalid URL")}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {return}
            print(data)
            do {
                let decoder = JSONDecoder()
                let gameDetail = try decoder.decode(GameDetailModel.self, from: data)
                completion(.success(gameDetail))
                
                print(gameDetail as Any)
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
}
