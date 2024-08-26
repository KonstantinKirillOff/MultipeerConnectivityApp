//
//  MultipeerViewModel.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import Foundation
import Combine
import MultipeerConnectivity

class MultipeerViewModel: ObservableObject {
    private let multipeerManager: MultipeerManager
    
    @Published var receivedMessages: [Message] = []
    @Published var availablePeers: Set<MCPeerID> = []
    @Published var sessionState = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(multipeerManager: MultipeerManager) {
        self.multipeerManager = multipeerManager
        
        multipeerManager.$sessionState
            .receive(on: DispatchQueue.main)
            .assign(to: \.sessionState, on: self)
            .store(in: &cancellables)
        
        multipeerManager.$receivedMessages
            .receive(on: DispatchQueue.main)
            .assign(to: \.receivedMessages, on: self)
            .store(in: &cancellables)
        
        multipeerManager.$availablePeers
            .receive(on: DispatchQueue.main)
            .assign(to: \.availablePeers, on: self)
            .store(in: &cancellables)
    }
    
    func startBrowser() {
        multipeerManager.startBrowser()
    }
    
    func startAdvertising() {
        multipeerManager.startAdvertising()
    }
    
    func disconnect() {
        multipeerManager.disconnect()
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        multipeerManager.invitePeer(peerID)
    }

    func sendMessage(text: String) {
        multipeerManager.sendMessage(text: text)
    }
}
