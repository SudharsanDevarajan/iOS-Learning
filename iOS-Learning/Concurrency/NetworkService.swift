//
//  NetworkService.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import Foundation

enum NetworkError:Error{
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct User: Codable{
    let name: String
    let email: String
    let username: String
}

class NetworkService{

    func fetchUser() async throws  -> User{
        
        let endPoint = "https://jsonplaceholder.typicode.com/users/1"
        guard let url = URL(string: endPoint) else{
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else{
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(User.self, from: data)
            return result
        } catch {
            throw NetworkError.invalidData
        }
    }
}
