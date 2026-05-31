//
//  Child.swift
//  NurseryConnectVision
//
//  Part B (visionOS) — re-uses the Part A NurseryConnect "Child" concept as a
//  lightweight value type for the seeded, in-memory Spatial Day Dashboard.
//

import Foundation

/// A child on the Keyworker's roster.
///
/// In Part A this was a SwiftData `@Model`; here it is a plain value type because
/// the visionOS prototype runs from a seeded in-memory store (no persistence).
struct Child: Identifiable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    /// Age in months — nurseries track under-fives in months, not years.
    var ageMonths: Int
    /// The key room the child belongs to (used as a peg label in the Volume).
    var roomGroup: String

    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        ageMonths: Int,
        roomGroup: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.ageMonths = ageMonths
        self.roomGroup = roomGroup
    }

    var fullName: String { "\(firstName) \(lastName)" }

    /// Short label for a peg in the 3D room (first name + last initial).
    var pegLabel: String { "\(firstName) \(lastName.prefix(1))." }

    /// Initials for a compact avatar.
    var initials: String {
        "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
    }

    var ageDescription: String {
        let years = ageMonths / 12
        let months = ageMonths % 12
        if years == 0 { return "\(months)m" }
        if months == 0 { return "\(years)y" }
        return "\(years)y \(months)m"
    }
}
