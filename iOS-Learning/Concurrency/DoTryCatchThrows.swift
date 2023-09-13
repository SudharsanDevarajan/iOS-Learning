//
//  DoTryCatchThrows.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import SwiftUI

enum CustomError: Error{
    case notPremiumUser
}

class doTryCatchDataManager{
    
    var isPremium: Bool = true
    
    func firstTitle() throws -> String{
        if isPremium{
            return "Your'e premium"
        }else{
            throw CustomError.notPremiumUser
        }
    }
}

class doTryCatchThrowsViewModel: ObservableObject{
    @Published var title: String = "My title"
    
    var dataManager = doTryCatchDataManager()
    
    func fetchTitle(){
        do{
            let newTitle = try dataManager.firstTitle()
            self.title = newTitle
        }catch let error{
            self.title = error.localizedDescription
        }
    }
}

struct doTryCatchThrowsView: View {
    @StateObject var vm = doTryCatchThrowsViewModel()
    
    var body: some View {
        VStack {
            Text(vm.title)
                .frame(width: 300, height: 300)
                .background(.black)
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    vm.fetchTitle()

                }
        }
        .padding()
    }
}

struct doTryCatchThrowsView_Previews: PreviewProvider {
    static var previews: some View {
        doTryCatchThrowsView()
    }
}
