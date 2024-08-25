//
//  MultipeerManager.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import Foundation
import MultipeerConnectivity

class MultipeerManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    private var peerID: MCPeerID!
    private var mcSession: MCSession!
    private var mcAdvertiser: MCAdvertiserAssistant!
    private var serviceBrowser: MCNearbyServiceBrowser!
    
    @Published var receivedMessages: [Message] = []
    @Published var availablePeers: [MCPeerID] = []
    
    override init() {
        super.init()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "mpchat")
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()

    }
    
    func startAdvertising() {
        mcAdvertiser = MCAdvertiserAssistant(serviceType: "mpchat", discoveryInfo: nil, session: mcSession)
        mcAdvertiser.start()
    }
    
    func sendMessage(message: String) {
        if mcSession.connectedPeers.count > 0 {
            if let textMessageData = message.data(using: .utf8) {
                do {
                    try mcSession.send(textMessageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error {
                    print("Error sending message: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    //MARK: MC delegate methods
    func invitePeer(_ peerID: MCPeerID) {
          let context = Data()
          serviceBrowser.invitePeer(peerID, to: mcSession, withContext: context, timeout: 10)
      }
      
      func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
      
      func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
          if let receivedText = String(data: data, encoding: .utf8) {
              DispatchQueue.main.async {
                  let message = Message(text: receivedText, sender: peerID.displayName)
                  self.receivedMessages.append(message)
              }
          }
      }
      
      func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
      
      func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
      
      func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

      func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
          DispatchQueue.main.async {
              self.availablePeers.append(peerID)
          }
      }
      
      func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
          DispatchQueue.main.async {
              self.availablePeers.removeAll { $0 == peerID }
          }
      }
}
