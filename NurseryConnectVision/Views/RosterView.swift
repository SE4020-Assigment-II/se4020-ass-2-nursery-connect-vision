//
//  RosterView.swift
//  NurseryConnectVision
//
//  The Keyworker's child roster list. Tapping a row selects that child, which
//  drives the ornament label and (from Phase D) the anchored 3D day panel.
//

import SwiftUI

struct RosterView: View {
    @Environment(DashboardViewModel.self) private var model

    var body: some View {
        List(model.children) { child in
            ChildRosterRow(child: child,
                           isSelected: model.selectedChildID == child.id)
                .contentShape(Rectangle())
                .onTapGesture { model.select(child) }
                .listRowBackground(
                    model.selectedChildID == child.id
                        ? Color.accentColor.opacity(0.25) : nil
                )
        }
        .listStyle(.inset)
    }
}
