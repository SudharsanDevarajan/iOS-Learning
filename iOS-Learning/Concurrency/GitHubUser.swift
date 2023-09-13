//
//  GitHubUser.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import SwiftUI

struct GitHubUser: View {
    
    let viewModel = NetworkService()
    
    @State private var user: User?
    
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
            Text("\(user?.username ?? "")")
            
            
            
            Text(user?.email ?? "Email")
                .foregroundColor(.gray)
        }
        .alert(isPresented: $isShowError, content: {
            Alert(title: Text(errorMsg))
        })
        .task {
            do{
                user = try await viewModel.fetchUser()
            }catch let error{
                isShowError = true
                errorMsg = error.localizedDescription
            }
        }
    }
}

struct GitHubUser_Previews: PreviewProvider {
    static var previews: some View {
        GitHubUser()
    }
}
