//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 16/10/23.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            // send the viewContent in SwiftUI environment - for SwiftUI query CoreData
            // send the whole dataController for SwiftUI to access
        }
    }
}
