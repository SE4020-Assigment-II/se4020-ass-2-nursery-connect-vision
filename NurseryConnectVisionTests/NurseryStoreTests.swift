//
//  NurseryStoreTests.swift
//  NurseryConnectVisionTests
//
//  Phase A — exercises the seeded store and the view model's derived summary
//  without launching the simulator. A pinned reference date keeps seeding
//  deterministic.
//

import Testing
import Foundation
@testable import NurseryConnectVision

@MainActor
struct NurseryStoreTests {
    let fixedDate = Date(timeIntervalSince1970: 1_750_000_000)

    @Test func seedsFiveChildren() {
        let store = NurseryStore.seeded(referenceDate: fixedDate)
        #expect(store.children.count == 5)
    }

    @Test func everyChildHasAtLeastOneEntry() {
        let store = NurseryStore.seeded(referenceDate: fixedDate)
        for child in store.children {
            #expect(!store.entries(for: child).isEmpty)
        }
    }

    @Test func entriesAreNewestFirst() {
        let store = NurseryStore.seeded(referenceDate: fixedDate)
        let child = store.children[0]
        let entries = store.entries(for: child)
        #expect(entries == entries.sorted { $0.timestamp > $1.timestamp })
    }

    @Test func summaryFlagsIncidentChild() {
        let store = NurseryStore.seeded(referenceDate: fixedDate)
        let vm = DashboardViewModel(store: store)
        let noah = store.children.first { $0.firstName == "Noah" }!
        #expect(vm.summary(for: noah).hasOpenIncident == true)
    }

    @Test func selectionDrivesPanelPresentation() {
        let store = NurseryStore.seeded(referenceDate: fixedDate)
        let vm = DashboardViewModel(store: store)
        #expect(vm.isPanelPresented == false)
        vm.select(store.children[0])
        #expect(vm.isPanelPresented == true)
        vm.clearSelection()
        #expect(vm.isPanelPresented == false)
    }
}
