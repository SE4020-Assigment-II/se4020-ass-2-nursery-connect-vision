//
//  DashboardViewModel.swift
//  NurseryConnectVision
//
//  Drives the roster window, the 3D volume selection, and the day panel.
//  Holds selection + panel state and derives the `DaySummary` shared by the
//  roster row, the anchored 3D panel (Phase D) and the unit tests.
//

import Foundation
import Observation

struct DaySummary: Equatable {
    let childName: String
    let entryCount: Int
    let latestWellbeing: WellbeingLevel?
    let hasOpenIncident: Bool
    let headlineNotes: [String]   // up to 3 most-recent notes
}

@Observable @MainActor
final class DashboardViewModel {
    let store: NurseryStore
    var selectedChildID: UUID?
    var isRoomOpen = false        // toggles the Volume (Phase C)

    init(store: NurseryStore) { self.store = store }

    var children: [Child] { store.children }

    var selectedChild: Child? {
        selectedChildID.flatMap { store.child(withID: $0) }
    }
    var isPanelPresented: Bool { selectedChild != nil }

    func select(_ child: Child) { selectedChildID = child.id }
    func clearSelection()       { selectedChildID = nil }

    func summary(for child: Child) -> DaySummary {
        let entries = store.entries(for: child)
        return DaySummary(
            childName: child.fullName,
            entryCount: entries.count,
            latestWellbeing: store.latestWellbeing(for: child),
            hasOpenIncident: store.hasOpenIncident(for: child),
            headlineNotes: Array(entries.prefix(3).map(\.note))
        )
    }
}
