//
//  ContentView.swift
//  ChatNew
//
//  Created by Denis Larin on 01.04.2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack{
            
            if status{
                
                Home()
                
            }
            else {
                NavigationView{
                    FirstPage()
                
                }
            }
        }.onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) {
                (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                
                self.status = status
                
            }        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FirstPage: View {
    
    @State var ccode = ""
    @State var no = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    
    var body: some View {
        
//        VStack(spacing: 10) {
          VStack {
            VStack {
            Image("pic")
                .resizable()
//                .frame(width: 350, height: 350)
            Text("Верификация Вашего номерa телефона")
                .font(.largeTitle)
//                .fontWeight(.heavy)
                .frame(width: UIScreen.main.bounds.width - 70, height: 150)
            
            Text("Пожалуйста введите Ваш номер телефона для верификации Вашего аккаунта")
                .font(.body)
                .foregroundColor(.gray)
//                .padding(.top, 12)
//                .padding()
                .frame(width: UIScreen.main.bounds.width - 70, height: 90)
            
            HStack(spacing: 20) {
            TextField("+7", text: $ccode)
                .keyboardType(.numberPad)
                .frame(width: 20, height: 25)
                .padding()
                .background(Color("Color"))
                .cornerRadius(10)
            
            TextField("Номер телефона", text: $no)
                .keyboardType(.numberPad)
                .padding()
                .background(Color("Color"))
                .cornerRadius(10)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 220, height: 25)
               
            }
//            .frame(width: UIScreen.main.bounds.width - 70, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .background(Color.white)
//            .clipShape(Rectangle())
//            .cornerRadius(10)
//            .shadow(color: Color.black.opacity(0.25),radius: 5, x: 5, y: 5)
//            .shadow(color: Color.black.opacity(0.15),radius: 5, x: -5, y: -5)
                
            .padding()
                
            NavigationLink(
                destination: ScndPage(show: $show, ID: $ID),
                isActive: $show) {
                
                Button(action: {
                    
//                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+"7"+self.no, uiDelegate: nil) { (ID, err) in
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+"7"+self.no, uiDelegate: nil) { (ID, err) in
                    
                        if err != nil{
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                    }
                    
//                    self.show.toggle()
                                                    
                }) {
                    
                    Text("Выслать")
                        .frame(width: UIScreen.main.bounds.width - 250, height: 40)
                }
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(13)
                    
            }
                
           
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
                
                
            }.padding()
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Ошибка"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ScndPage: View {
    
    @State var code = ""
    @Binding var show: Bool
    @Binding var ID: String
    @State var msg = ""
    @State var alert = false
    
    var body: some View {
        
//        VStack(spacing: 10) {
        ZStack(alignment: .topLeading) {
            
            GeometryReader{_ in
                
                VStack {
                  VStack {
                  Image("pic")
                      .resizable()
      //                .frame(width: 350, height: 350)
                  Text("Верификационный код")
                      .font(.largeTitle)
      //                .fontWeight(.heavy)
                      .frame(width: UIScreen.main.bounds.width - 70, height: 90)
                  
                  Text("Пожалуйста введите присланный Вам верификационный код")
                      .font(.body)
                      .foregroundColor(.gray)
      //                .padding(.top, 12)
      //                .padding()
                      .frame(width: UIScreen.main.bounds.width - 70, height: 90)
                  
      //            HStack(spacing: 20) {
                    TextField("Код", text: self.$code)
                      .keyboardType(.numberPad)
                      .frame(width: 70, height: 25)
                      .padding()
                      .background(Color("Color"))
                      .cornerRadius(10)
                  
      //            TextField("Номер телефона", text: $no)
      //                .keyboardType(.numberPad)
      //                .padding()
      //                .background(Color("Color"))
      //                .cornerRadius(10)
      ////                .clipShape(RoundedRectangle(cornerRadius: 10))
      //                .frame(width: 220, height: 25)
      //
      //            }
      //            .frame(width: UIScreen.main.bounds.width - 70, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      //            .background(Color.white)
      //            .clipShape(Rectangle())
      //            .cornerRadius(10)
      //            .shadow(color: Color.black.opacity(0.25),radius: 5, x: 5, y: 5)
      //            .shadow(color: Color.black.opacity(0.15),radius: 5, x: -5, y: -5)
                      
                  .padding()
                  Button(action: {
                    
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                    
                    Auth.auth().signIn(with: credential) { (res, err) in
                        
                        if err != nil{
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        UserDefaults.standard.set(true, forKey: "status")
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        
                    }
                  }) {
                      
                      Text("Верифицировать")
                          .frame(width: UIScreen.main.bounds.width - 190, height: 40)
                  }
                  .foregroundColor(.white)
                  .background(Color.blue)
                  .cornerRadius(13)
                  .navigationTitle("")
                  .navigationBarHidden(true)
                  .navigationBarBackButtonHidden(true)
                      
                  }
                
            }
                Button(action: {
                    
                    self.show.toggle()
                    
               
                }) {
                    HStack{
                    Image(systemName: "chevron.left")
                        .font(.title)
                    Text("Назад")
                    }
                }.foregroundColor(.blue)
            
            }
        
          .padding()
            
          .alert(isPresented: $alert) {
                
                Alert(title: Text("Ошибка"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
          }
        
        }
    }
}



