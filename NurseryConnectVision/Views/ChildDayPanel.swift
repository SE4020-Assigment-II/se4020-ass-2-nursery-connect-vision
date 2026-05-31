//
//  ChildDayPanel.swift
//  NurseryConnectVision
//
//  The SwiftUI card that anchors beside a tapped peg in the 3D volume.
//  Reuses `DaySummary` (Phase A) so the same derived data drives the roster
//  row and this spatial panel.
//

import SwiftUI

struct ChildDayPanel: View {
    @Environment(DashboardViewModel.self) private var model
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let child: Child

    private var summary: DaySummary { model.summary(for: child) }

    var body: some View {
        let card = VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(child.fullName).font(.title2.bold())
                Spacer()
                Button {
                    model.clearSelection()
                } label: { Image(systemName: "xmark.circle.fill") }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close \(child.firstName)’s day")
            }

            Label(summary.latestWellbeing?.label ?? "No wellbeing logged",
                  systemImage: summary.latestWellbeing?.symbol ?? "questionmark")

            if summary.hasOpenIncident {
                Label("Open incident — see report", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
            }

            Divider()

            Text("Today (\(summary.entryCount) entries)")
                .font(.headline)
            ForEach(Array(summary.headlineNotes.enumerated()), id: \.offset) { _, note in
                Text("• \(note)").font(.callout)
            }
        }
        .padding(20)
        .frame(width: 320)

        // Phase E: solid material when Reduce Transparency is on, glass otherwise.
        return Group {
            if reduceTransparency {
                card.background(.regularMaterial, in: .rect(cornerRadius: 20))
            } else {
                card.glassBackgroundEffect()
            }
        }
    }
}
