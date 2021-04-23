//
//  ChatPage.swift
//  ChatNew
//
//  Created by Denis Larin on 01.04.2021.
//

import Foundation
import SwiftUI
import Firebase

struct Home: View {
    
    var body: some View {
        HStack{
        VStack(alignment: .leading, spacing: 10){
            Button(action: {
                
                try! Auth.auth().signOut()
                
                UserDefaults.standard.set(false, forKey: "status")
                
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            })
            {
                Text("Выйти")
            }
            .frame(width: 90, height: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(13)
            Spacer()
            
        }
            Spacer(minLength: 0)
       
        }.padding()
        .font(.title2)
                    
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
