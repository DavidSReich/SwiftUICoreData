//
//  SwiftUICoreDataApp.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 15/11/20.
//

import SwiftUI

@main
struct SwiftUICoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
