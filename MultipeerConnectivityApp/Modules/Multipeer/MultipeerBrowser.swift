//
//  MultipeerBrowser.swift
//  MultipeerConnectivityApp
//
//  Created by Konstantin Kirillov on 25.08.2024.
//
//
//import SwiftUI
//import MultipeerConnectivity
//
//struct MultipeerBrowserView: UIViewControllerRepresentable {
//    @ObservedObject var viewModel: MultipeerViewModel
//    
//    func makeUIViewController(context: Context) -> MCBrowserViewController {
//        let browser = MCBrowserViewController(serviceType: "chatt", session: viewModel.mcSession)
//        browser.delegate = viewModel
//        return browser
//    }
//    
//    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {}
//    
//    class Coordinator: NSObject, MCBrowserViewControllerDelegate {
//        var parent: MultipeerBrowser
//
//        init(parent: MultipeerBrowser) {
//            self.parent = parent
//        }
//
//        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
//            parent.viewModel.browserViewControllerDidFinish(browserViewController)
//        }
//
//        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
//            parent.viewModel.browserViewControllerWasCancelled(browserViewController)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//}

//import SwiftUI
//import MultipeerConnectivity
//
//struct MultipeerBrowserView: UIViewControllerRepresentable {
//    @ObservedObject var viewModel: MultipeerViewModel
//    
//    func makeUIViewController(context: Context) -> MCBrowserViewController {
//        viewModel.mcBrowser!
//    }
//    
//    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
//        // Ничего не делаем, так как UI обновляется самостоятельно.
//    }
//}
