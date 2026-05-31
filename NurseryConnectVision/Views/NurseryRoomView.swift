//
//  NurseryRoomView.swift
//  NurseryConnectVision
//
//  Hosts the programmatic nursery room in a RealityView and wires the three
//  required spatial interactions:
//    1. Tap a peg  -> the child's day panel floats out, anchored in 3D.
//    2. Drag       -> rotate the whole room (walk-around the volume).
//    3. Chime      -> spatial confirmation sound from the tapped peg.
//
//  Phase E: respects Reduce Motion (no spring on select, gentler rotate).
//

import SwiftUI
import RealityKit

struct NurseryRoomView: View {
    @Environment(DashboardViewModel.self) private var model
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        RealityView { content, _ in
            let room = NurseryRoomBuilder.makeRoom(children: model.children)
            room.name = "RoomRoot"
            room.position = [0, -0.15, 0]
            content.add(room)
        } update: { content, attachments in
            // Anchor the panel attachment above-and-in-front of the selected peg,
            // clear of the floating name plates.
            guard let root = content.entities.first(where: { $0.name == "RoomRoot" }) else { return }
            root.children.filter { $0.name == "PanelAnchor" }.forEach { $0.removeFromParent() }

            if let child = model.selectedChild,
               let peg = root.findEntity(named: "Peg-\(child.id.uuidString)"),
               let panel = attachments.entity(for: "dayPanel") {
                let anchor = Entity()
                anchor.name = "PanelAnchor"
                anchor.position = peg.position(relativeTo: root) + [0, 0.22, 0.16]
                anchor.addChild(panel)
                root.addChild(anchor)
            }
        } attachments: {
            if let child = model.selectedChild {
                Attachment(id: "dayPanel") {
                    ChildDayPanel(child: child)
                        .environment(model)
                        .transition(reduceMotion
                                    ? .opacity
                                    : .move(edge: .top).combined(with: .opacity))
                }
            }
        }
        // (1) Tap a peg -> resolve child -> select + chime.
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    var entity: Entity? = value.entity
                    // Walk up to the peg that carries the ChildTagComponent.
                    while let e = entity, e.components[ChildTagComponent.self] == nil {
                        entity = e.parent
                    }
                    guard let peg = entity,
                          let tag = peg.components[ChildTagComponent.self],
                          let child = model.store.child(withID: tag.childID) else { return }
                    withAnimation(reduceMotion ? nil : .spring) { model.select(child) }
                    AudioCue.playChime(from: peg)
                }
        )
        // (2) Drag the room to rotate it (walk-around / manipulate the volume).
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let root = value.entity.scene?
                        .findEntity(named: "RoomRoot") else { return }
                    let sensitivity: Float = reduceMotion ? 0.0025 : 0.005
                    let dx = Float(value.translation.width)
                    root.orientation = simd_quatf(angle: dx * sensitivity, axis: [0, 1, 0])
                }
        )
    }
}
