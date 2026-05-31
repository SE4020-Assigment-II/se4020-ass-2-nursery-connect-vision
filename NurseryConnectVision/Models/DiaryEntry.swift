//
//  DiaryEntry.swift
//  NurseryConnectVision
//
//  Mirrors the Part A diary: five entry kinds + a four-point wellbeing scale.
//

import Foundation

/// The five diary-entry kinds the Keyworker logs (from Part A).
enum DiaryEntryType: String, CaseIterable, Identifiable {
    case activity, meal, nap, nappy, wellbeing
    var id: String { rawValue }

    var title: String {
        switch self {
        case .activity:  "Activity"
        case .meal:      "Meal"
        case .nap:       "Nap"
        case .nappy:     "Nappy"
        case .wellbeing: "Wellbeing"
        }
    }

    /// SF Symbol used on roster rows and the day panel.
    var symbol: String {
        switch self {
        case .activity:  "figure.play"
        case .meal:      "fork.knife"
        case .nap:       "moon.zzz.fill"
        case .nappy:     "drop.fill"
        case .wellbeing: "heart.fill"
        }
    }
}

/// A child's emotional state at a point in the day.
enum WellbeingLevel: Int, CaseIterable, Identifiable, Comparable {
    case upset = 0, unsettled, settled, happy
    var id: Int { rawValue }

    var label: String {
        switch self {
        case .upset:     "Upset"
        case .unsettled: "Unsettled"
        case .settled:   "Settled"
        case .happy:     "Happy"
        }
    }

    var symbol: String {
        switch self {
        case .upset:     "cloud.rain.fill"
        case .unsettled: "cloud.fill"
        case .settled:   "sun.max.fill"
        case .happy:     "sparkles"
        }
    }

    static func < (lhs: WellbeingLevel, rhs: WellbeingLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// One logged diary moment for a child.
struct DiaryEntry: Identifiable, Hashable {
    let id: UUID
    let childID: UUID
    var type: DiaryEntryType
    var timestamp: Date
    var note: String
    /// Only set when `type == .wellbeing`.
    var wellbeing: WellbeingLevel?

    init(id: UUID = UUID(), childID: UUID, type: DiaryEntryType,
         timestamp: Date, note: String, wellbeing: WellbeingLevel? = nil) {
        self.id = id; self.childID = childID; self.type = type
        self.timestamp = timestamp; self.note = note; self.wellbeing = wellbeing
    }
}
