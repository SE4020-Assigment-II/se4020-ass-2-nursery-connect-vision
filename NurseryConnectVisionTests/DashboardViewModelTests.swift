//
//  DashboardViewModelTests.swift
//  NurseryConnectVisionTests
//
//  Edge-case coverage for the view model that drives the roster row, the 3D
//  day panel, and the volume toggle. Complements NurseryStoreTests (Phase A).
//

import Testing
import Foundation
@testable import NurseryConnectVision

@MainActor
struct DashboardViewModelTests {
    let fixedDate = Date(timeIntervalSince1970: 1_750_000_000)

    private func makeVM() -> DashboardViewModel {
        DashboardViewModel(store: .seeded(referenceDate: fixedDate))
    }

    @Test func rapidReselectionKeepsLatestChild() {
        let vm = makeVM()
        vm.select(vm.children[0])
        vm.select(vm.children[1])
        vm.select(vm.children[2])
        #expect(vm.selectedChildID == vm.children[2].id)
        #expect(vm.isPanelPresented)
    }

    @Test func clearSelectionDismissesPanel() {
        let vm = makeVM()
        vm.select(vm.children[0])
        #expect(vm.isPanelPresented)
        vm.clearSelection()
        #expect(vm.selectedChildID == nil)
        #expect(vm.isPanelPresented == false)
        #expect(vm.selectedChild == nil)
    }

    @Test func summaryCapsHeadlineNotesAtThree() {
        let vm = makeVM()
        for child in vm.children {
            #expect(vm.summary(for: child).headlineNotes.count <= 3)
        }
    }

    @Test func childWithoutWellbeingReportsNilLevel() {
        // Build a store with one child + a single non-wellbeing entry.
        let kid = Child(firstName: "Test", lastName: "Child", ageMonths: 24, roomGroup: "Toddlers")
        let entry = DiaryEntry(childID: kid.id, type: .meal, timestamp: fixedDate, note: "Lunch")
        let store = NurseryStore(children: [kid], diaryEntries: [entry], incidents: [])
        let vm = DashboardViewModel(store: store)
        #expect(vm.summary(for: kid).latestWellbeing == nil)
        #expect(vm.summary(for: kid).entryCount == 1)
    }

    @Test func incidentFreeChildHasNoFlag() {
        let vm = makeVM()
        let amaya = vm.children.first { $0.firstName == "Amaya" }!
        #expect(vm.summary(for: amaya).hasOpenIncident == false)
    }

    @Test func noahHasOpenIncidentFlag() {
        let vm = makeVM()
        let noah = vm.children.first { $0.firstName == "Noah" }!
        #expect(vm.summary(for: noah).hasOpenIncident)
    }

    @Test func summaryNameMatchesChild() {
        let vm = makeVM()
        let child = vm.children[0]
        #expect(vm.summary(for: child).childName == child.fullName)
    }

    @Test func roomToggleStartsClosed() {
        #expect(makeVM().isRoomOpen == false)
    }
}
