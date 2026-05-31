//
//  NurseryStore.swift
//  NurseryConnectVision
//
//  In-memory, seeded source of truth for the Spatial Day Dashboard.
//  No SwiftData / CloudKit — a plain `@Observable` holding value types.
//

import Foundation
import Observation

@Observable
final class NurseryStore {
    private(set) var children: [Child]
    private(set) var diaryEntries: [DiaryEntry]
    private(set) var incidents: [IncidentReport]

    init(children: [Child], diaryEntries: [DiaryEntry], incidents: [IncidentReport]) {
        self.children = children
        self.diaryEntries = diaryEntries
        self.incidents = incidents
    }

    // MARK: Lookups

    func entries(for child: Child) -> [DiaryEntry] {
        diaryEntries.filter { $0.childID == child.id }
            .sorted { $0.timestamp > $1.timestamp }
    }

    func incidents(for child: Child) -> [IncidentReport] {
        incidents.filter { $0.childID == child.id }
    }

    func latestWellbeing(for child: Child) -> WellbeingLevel? {
        entries(for: child).first { $0.type == .wellbeing }?.wellbeing
    }

    func hasOpenIncident(for child: Child) -> Bool {
        !incidents(for: child).isEmpty
    }

    func child(withID id: UUID) -> Child? {
        children.first { $0.id == id }
    }
}

extension NurseryStore {
    /// Seeded, demo-ready store (no persistence). Used by the app and previews.
    /// Fixed `UUID`s aren't needed — children are addressed by their seeded
    /// identities — but timestamps are relative to `referenceDate` so tests are
    /// deterministic when they pin the date.
    static func seeded(referenceDate now: Date = Date()) -> NurseryStore {
        func at(_ hoursAgo: Double) -> Date { now.addingTimeInterval(-hoursAgo * 3600) }

        let amaya = Child(firstName: "Amaya",  lastName: "Khan",    ageMonths: 28, roomGroup: "Toddlers")
        let noah  = Child(firstName: "Noah",   lastName: "Bennett", ageMonths: 19, roomGroup: "Toddlers")
        let liwa  = Child(firstName: "Liwa",   lastName: "Osei",    ageMonths: 34, roomGroup: "Preschool")
        let mei   = Child(firstName: "Mei",    lastName: "Tanaka",  ageMonths: 11, roomGroup: "Babies")
        let theo  = Child(firstName: "Theo",   lastName: "Garcia",  ageMonths: 41, roomGroup: "Preschool")
        let kids  = [amaya, noah, liwa, mei, theo]

        let entries: [DiaryEntry] = [
            DiaryEntry(childID: amaya.id, type: .meal,      timestamp: at(2), note: "Ate most of her lunch."),
            DiaryEntry(childID: amaya.id, type: .wellbeing, timestamp: at(1), note: "Cheerful all morning.", wellbeing: .happy),
            DiaryEntry(childID: noah.id,  type: .nap,       timestamp: at(3), note: "Slept 45 min."),
            DiaryEntry(childID: noah.id,  type: .wellbeing, timestamp: at(1), note: "A bit clingy after nap.", wellbeing: .unsettled),
            DiaryEntry(childID: liwa.id,  type: .activity,  timestamp: at(2), note: "Built a tall block tower."),
            DiaryEntry(childID: liwa.id,  type: .wellbeing, timestamp: at(1), note: "Settled and focused.", wellbeing: .settled),
            DiaryEntry(childID: mei.id,   type: .nappy,     timestamp: at(1), note: "Changed at 11:15."),
            DiaryEntry(childID: mei.id,   type: .wellbeing, timestamp: at(2), note: "Tearful before nap.", wellbeing: .upset),
            DiaryEntry(childID: theo.id,  type: .activity,  timestamp: at(2), note: "Painting — very proud."),
            DiaryEntry(childID: theo.id,  type: .wellbeing, timestamp: at(1), note: "Happy and chatty.", wellbeing: .happy),
        ]

        let incidents: [IncidentReport] = [
            IncidentReport(childID: noah.id, timestamp: at(4),
                           summary: "Bumped head on play mat edge.",
                           actionTaken: "Cold compress applied; parents informed.",
                           severity: .minor, reportedBy: "Keyworker"),
        ]
        return NurseryStore(children: kids, diaryEntries: entries, incidents: incidents)
    }
}
