//
//  ContentView.swift
//  NurseryConnectVision
//
//  Created by FocalDive on 2026-05-30.
//
//  Hosts the Keyworker's child roster (the flat Window surface) plus a floating
//  ornament toolbar. The 3D Volume is added in Phase C.
//

import SwiftUI

struct ContentView: View {
    @Environment(DashboardViewModel.self) private var model

    var body: some View {
        @Bindable var model = model
        NavigationStack {
            RosterView()
                .navigationTitle("Today’s Room")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Label("\(model.children.count) children",
                              systemImage: "person.2.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
        }
        // Floating ornament toolbar beside the window.
        .ornament(attachmentAnchor: .scene(.bottom)) {
            DashboardOrnament()
        }
    }
}

/// Floating control strip — toggles the 3D room (wired fully in Phase C) and
/// shows the current selection.
private struct DashboardOrnament: View {
    @Environment(DashboardViewModel.self) private var model

    var body: some View {
        @Bindable var model = model
        HStack(spacing: 16) {
            Toggle(isOn: $model.isRoomOpen) {
                Label("Nursery Room", systemImage: "cube.transparent")
            }
            .toggleStyle(.button)

            Divider().frame(height: 24)

            if let child = model.selectedChild {
                Label(child.fullName, systemImage: "person.crop.circle.fill")
            } else {
                Text("No child selected").foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 12)
        .glassBackgroundEffect()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(DashboardViewModel(store: .seeded()))
}
