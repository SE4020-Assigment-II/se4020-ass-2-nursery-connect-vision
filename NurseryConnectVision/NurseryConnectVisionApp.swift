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
import RealityKit

@main
struct NurseryConnectVisionApp: App {
    @State private var model = DashboardViewModel(store: .seeded())

    init() {
        ChildTagComponent.registerComponent()
    }

    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .defaultSize(width: 520, height: 680)

        WindowGroup(id: "nurseryRoom") {
            NurseryRoomView()
                .environment(model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)
    }
}
