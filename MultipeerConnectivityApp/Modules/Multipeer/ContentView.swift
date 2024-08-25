//
//  ContentView.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

//import SwiftUI
//
//struct ContentView: View {
//    @StateObject var viewModel: MultipeerViewModel
//    @State private var messageText = ""
//    @State private var isBrowserShow = false
//    
//    var body: some View {
//        VStack {
//            List(viewModel.receivedMessages, id: \.id) { message in
//                VStack {
//                    Text("from: \(message.sender)")
//                    Text(message.text)
//                    
//                }
//                .frame(width: .infinity, alignment: .leading)
//            }
//            Spacer()
//            HStack {
//                TextField("Enter your message", text: $messageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                Button(action: {
//                    viewModel.sendMessage(text: messageText)
//                    messageText = ""
//                }, label: {
//                    Text("Send")
//                })
//            }
//            VStack {
//                Button(action: {
//                    viewModel.startAdvertising()
//                }, label: {
//                    Text("Advertise")
//                })
//                .padding()
//                
//                List(viewModel.availablePeers, id: \.self) { peerID in
//                    Button(action: {
//                        viewModel.invitePeer(peerID)
//                    }) {
//                        Text(peerID.displayName)
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $isBrowserShow) {
//            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
//        }
//
//    }
//}

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: MultipeerViewModel
    @State private var messageText: String = ""
    @State private var connectionStatus = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Session state: \(viewModel.sessionState)")
            List(viewModel.receivedMessages) { message in
                Text("\(message.sender): \(message.text)")
            }
            
            HStack {
                TextField("Enter your message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    viewModel.sendMessage(text: messageText)
                    messageText = ""
                }
            }
            
            Button("Advertise") {
                viewModel.startAdvertising()
            }
            
            Button("Browse") {
                viewModel.startBrowser()
            }
            
            Button("Disconnect") {
                viewModel.disconnect()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: MultipeerViewModel())
}
