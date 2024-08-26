//
//  MultipeerManager.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import Foundation
import MultipeerConnectivity

final class MultipeerManager: NSObject {
    @Published var receivedMessages: [Message] = []
    @Published var availablePeers = Set<MCPeerID>()
    @Published var sessionState = ""
    
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    private var mcSession: MCSession?
    private var mcAdvertiser: MCNearbyServiceAdvertiser?
    private var mcBrowser: MCNearbyServiceBrowser?
    private let serviceType = "chatt"
    
    override init() {
        super.init()
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        startBrowser()
    }
    
    func startBrowser() {
        mcBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        mcBrowser?.delegate = self
        mcBrowser?.startBrowsingForPeers()
    }
    
    func startAdvertising() {
        stopBrowsingAndAdvertising()
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        mcAdvertiser?.delegate = self
        mcAdvertiser?.startAdvertisingPeer()
    }
    
    func disconnect() {
        mcSession?.connectedPeers.forEach { peerId in
            mcSession?.cancelConnectPeer(peerId)
        }
        stopBrowsingAndAdvertising()
        startBrowser()
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        guard let session = mcSession else { return }
        mcBrowser?.invitePeer(peerID, to: session, withContext: nil, timeout: 10.0)
    }

    func sendMessage(text: String) {
        guard let session = mcSession else { return }
        if session.connectedPeers.count > 0 {
            if let textData = text.data(using: .utf8) {
                do {
                    try session.send(textData, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    print("Error sending message: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func stopBrowsingAndAdvertising() {
        if let browser = mcBrowser {
            browser.stopBrowsingForPeers()
        }
        
        if let advertiser = mcAdvertiser {
            advertiser.stopAdvertisingPeer()
        }
        
        mcSession?.disconnect()
    }
}

//MARK: - MCSessionDelegate methods
extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            DispatchQueue.main.async {
                self.sessionState = "connected"
            }
        case .connecting:
            DispatchQueue.main.async {
                self.sessionState = "connecting"
            }
        case .notConnected:
            DispatchQueue.main.async {
                self.sessionState = "not connected"
            }
        default:
            DispatchQueue.main.async {
                self.sessionState = "unknown status for"
            }
        }
    }
    
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
}

extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            self.availablePeers.insert(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availablePeers.remove(peerID)
        }
    }
}
