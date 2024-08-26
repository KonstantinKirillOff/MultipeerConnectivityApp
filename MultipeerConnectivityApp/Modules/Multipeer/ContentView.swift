//
//  ContentView.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: MultipeerViewModel
    @State private var messageText: String = ""
    @State private var connectionStatus = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Messages:")
                .font(.title2)
            List(viewModel.receivedMessages) { message in
                VStack {
                    Text("\(message.sender): \(message.text)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            
            if !viewModel.availablePeers.isEmpty {
                Text("Advertisers:")
                    .font(.title2)
                List(Array(viewModel.availablePeers), id: \.self) { peerID in
                    Button(action: {
                        viewModel.invitePeer(peerID)
                    }) {
                        Text(peerID.displayName)
                    }
                }
            }
            
            HStack {
                TextField("Enter your message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    viewModel.sendMessage(text: messageText)
                    messageText = ""
                }
            }
            
            Text("Session state: \(viewModel.sessionState)")
            HStack(spacing: 20) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: MultipeerViewModel(multipeerManager: MultipeerManager()))
}
