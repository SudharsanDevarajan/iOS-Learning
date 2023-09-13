//
//  GitHubUser.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import SwiftUI

enum NetworkError:Error{
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct AsyncAwait: View {
    
    
    @State private var user: UserProfile?
    
    @State var isShowError: Bool = false
    @State var errorMsg: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            AsyncImage(url: URL(string: "https://picsum.photos/200")){image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            }placeholder: {
                Circle()
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 120)
            
            
            Text(user?.name ?? "Username")
            Text("\(user?.name ?? "")")
            Text(user?.email ?? "Email")
                .foregroundColor(.gray)
        }
        .alert(isPresented: $isShowError, content: {
            Alert(title: Text(errorMsg))
        })
        .task {
            do{
                user = try await fetchUser()
            }catch let error{
                isShowError = true
                errorMsg = error.localizedDescription
            }
        }
    }
    
    func fetchUser() async throws  -> UserProfile{
        
        let endPoint = "https://jsonplaceholder.typicode.com/users/1"
        guard let url = URL(string: endPoint) else{
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else{
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(UserProfile.self, from: data)
            return result
        } catch {
            throw NetworkError.invalidData
        }
    }
}

struct GitHubUser_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait()
    }
}
