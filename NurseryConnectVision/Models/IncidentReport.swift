//
//  IncidentReport.swift
//  NurseryConnectVision
//
//  RIDDOR-style report. Immutable (all `let`) — Part A's rule that an incident,
//  once filed, cannot be edited.
//

import Foundation

struct IncidentReport: Identifiable, Hashable {
    enum Severity: String, CaseIterable { case minor, moderate, serious }

    let id: UUID
    let childID: UUID
    let timestamp: Date
    let summary: String
    let actionTaken: String
    let severity: Severity
    let reportedBy: String

    init(id: UUID = UUID(), childID: UUID, timestamp: Date, summary: String,
         actionTaken: String, severity: Severity, reportedBy: String) {
        self.id = id; self.childID = childID; self.timestamp = timestamp
        self.summary = summary; self.actionTaken = actionTaken
        self.severity = severity; self.reportedBy = reportedBy
    }
}
