//
//  ChildRosterRow.swift
//  NurseryConnectVision
//
//  One roster row: avatar initials, name/age/entry-count, latest wellbeing
//  icon, and an incident flag. Reads its `DaySummary` from the view model.
//

import SwiftUI

struct ChildRosterRow: View {
    @Environment(DashboardViewModel.self) private var model
    let child: Child
    let isSelected: Bool

    private var summary: DaySummary { model.summary(for: child) }

    var body: some View {
        HStack(spacing: 14) {
            Text(child.initials)
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(.tertiary, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(child.fullName).font(.headline)
                Text("\(child.roomGroup) · \(child.ageDescription) · \(summary.entryCount) entries")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Spacer()

            if let wb = summary.latestWellbeing {
                Label(wb.label, systemImage: wb.symbol)
                    .labelStyle(.iconOnly)
                    .accessibilityLabel("Wellbeing: \(wb.label)")
            }
            if summary.hasOpenIncident {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("Open incident")
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
