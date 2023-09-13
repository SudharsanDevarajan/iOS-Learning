//
//  AsyncLet.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import SwiftUI
import MapKit

struct UserProfile: Codable{
    let id: Int
    let name: String
    let email: String
    let address: userAddress
    let website: String
    
}

struct userAddress: Codable{
    let street: String
    let city: String
}

// Async let used to fetch multiple async func at same time
struct AsyncLet: View {
    
    let imageUrl = URL(string: "https://picsum.photos/200")!
    let userDetailUrl = URL(string: "https://jsonplaceholder.typicode.com/users/2")!
    
    
    @State private var userImage: UIImage?
    @State var user: UserProfile?
    
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                if let image = userImage,let details = user{
                    ProfileHeader(profilePic: image, user: details)
                }else{
                    ProgressView()
                }
            }
            .navigationTitle("Async Let 🤩")
        }
        .task {
            do{
                async let userDetails = fetchUserProfile()
                async let userImage = fetchUserImage()
                let (details, image) = await (try userDetails,try userImage)
                self.userImage = image
                self.user = details
            }catch{
                print(error.localizedDescription)
            }
        }
    }
 
    
    func fetchUserImage() async throws -> UIImage{
        do {
            let (data,_) = try await URLSession.shared.data(from: imageUrl)
            if let image = UIImage(data: data){
                return image
            }else{
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
    
    func fetchUserProfile() async throws -> UserProfile{
        do{
            let (data,_) = try await URLSession.shared.data(from: userDetailUrl)
            let result = try JSONDecoder().decode(UserProfile.self, from: data)
            return result
        }catch{
            throw error
        }
    }
}

struct AsyncLet_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLet()
    }
}

struct ProfileHeader: View{
    
    var profilePic: UIImage
    var user: UserProfile
    
    var body: some View{
        VStack{
            Image(uiImage: profilePic)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120, alignment: .leading)
                .clipShape(Circle())
            
            Text(user.name)
                .font(.title)
            Text(user.email)
            
            Text(user.website)
        }
    }
}
