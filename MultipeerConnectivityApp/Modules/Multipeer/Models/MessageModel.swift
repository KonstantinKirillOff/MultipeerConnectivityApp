//
//  MessageModel.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let sender: String
}
