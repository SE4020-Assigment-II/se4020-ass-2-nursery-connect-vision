//
//  NurseryRoomView.swift
//  NurseryConnectVision
//
//  Hosts the programmatic nursery room in a RealityView. Phase C renders the
//  scene; Phase D adds the tap gesture, anchored panel attachment, and audio.
//

import SwiftUI
import RealityKit

struct NurseryRoomView: View {
    @Environment(DashboardViewModel.self) private var model

    var body: some View {
        RealityView { content in
            let room = NurseryRoomBuilder.makeRoom(children: model.children)
            room.position = [0, -0.15, 0]            // sit on the volume floor
            content.add(room)
        }
        // Phase D will add `.gesture(SpatialTapGesture()…)`, attachments, and audio.
    }
}
