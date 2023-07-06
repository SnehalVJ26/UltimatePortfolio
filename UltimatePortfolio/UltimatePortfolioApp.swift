//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by mnameit on 21/06/23.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            NavigationSplitView(sidebar: {
                SidebarView()
            }, content: {
                ContentView()
            }, detail: {
                DetailView()
            })
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}

