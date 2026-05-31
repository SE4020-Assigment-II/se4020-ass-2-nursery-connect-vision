//
//  NurseryConnectVisionApp.swift
//  NurseryConnectVision
//
//  Created by FocalDive on 2026-05-30.
//
//  Creates the seeded store + view model once and injects them into the
//  environment. The 3D volume scene is added in Phase C.
//

import SwiftUI

@main
struct NurseryConnectVisionApp: App {
    @State private var model = DashboardViewModel(store: .seeded())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .defaultSize(width: 520, height: 680)
        // Phase C adds: WindowGroup(id: "nurseryRoom") { … }.windowStyle(.volumetric)
    }
}
