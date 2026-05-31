//
//  NurseryRoomBuilder.swift
//  NurseryConnectVision
//
//  Builds the bounded nursery-room scene entirely in code (no Reality Composer
//  Pro): floor + two walls + a row of coloured "pegs", one per child, each with
//  a centred floating name plate. Every peg is interaction-ready (tag, input
//  target, styled hover, collision, accessibility) so Phase D wires taps and
//  Phase E gets clean affordances without rebuilding.
//

import RealityKit
import SwiftUI
import UIKit

enum NurseryRoomBuilder {
    /// Builds the room sized to sit inside a ~0.6 m volumetric window.
    static func makeRoom(children: [Child]) -> Entity {
        let root = Entity()
        root.name = "RoomRoot"

        root.addChild(makeFloor())
        // A single low back wall behind the pegs reads as a locker unit without
        // occluding the day panel (the old left wall jutted toward the viewer).
        root.addChild(makeWall(width: 0.6, at: [0, 0.08, -0.3]))

        // Row of pegs along the back, evenly spaced and centred.
        let spacing: Float = 0.11
        let startX = -spacing * Float(children.count - 1) / 2
        for (i, child) in children.enumerated() {
            let peg = makePeg(for: child, index: i)
            peg.position = [startX + spacing * Float(i), 0.10, -0.22]
            root.addChild(peg)
        }

        // Phase E: directional fill so materials aren't flat + soft contact shadow.
        let light = DirectionalLight()
        light.light.intensity = 1200
        light.light.color = .white
        light.shadow = DirectionalLightComponent.Shadow()
        light.orientation = simd_quatf(angle: -.pi / 3, axis: [1, 0.2, 0])
        root.addChild(light)

        return root
    }

    // MARK: Pieces

    private static func makeFloor() -> Entity {
        let mesh = MeshResource.generatePlane(width: 0.6, depth: 0.6, cornerRadius: 0.02)
        let mat  = SimpleMaterial(color: .init(white: 0.85, alpha: 1), isMetallic: false)
        let floor = ModelEntity(mesh: mesh, materials: [mat])
        floor.name = "Floor"
        return floor
    }

    /// A low back wall that sits just behind and around peg height, framing the
    /// lockers without towering over them or blocking the floating panel.
    private static func makeWall(width: Float, at position: SIMD3<Float>) -> Entity {
        let mesh = MeshResource.generateBox(width: width, height: 0.16, depth: 0.01,
                                            cornerRadius: 0.004)
        let mat  = SimpleMaterial(color: .init(white: 0.92, alpha: 1), isMetallic: false)
        let wall = ModelEntity(mesh: mesh, materials: [mat])
        wall.position = position
        return wall
    }

    /// A coloured locker box + centred floating name label, fully tap-ready.
    private static func makePeg(for child: Child, index: Int) -> Entity {
        let peg = Entity()
        peg.name = "Peg-\(child.id.uuidString)"

        let box = ModelEntity(
            mesh: .generateBox(width: 0.08, height: 0.10, depth: 0.04, cornerRadius: 0.012),
            materials: [SimpleMaterial(color: pegColor(index), isMetallic: false)]
        )
        peg.addChild(box)

        // Floating name plate, centred above the locker.
        let label = ModelEntity(
            mesh: .generateText(child.pegLabel,
                                extrusionDepth: 0.001,
                                font: .systemFont(ofSize: 0.014),
                                alignment: .center),
            materials: [UnlitMaterial(color: .white)]
        )
        // generateText anchors at the baseline-left; recentre it over the peg.
        let textWidth = label.visualBounds(relativeTo: nil).extents.x
        label.position = [-textWidth / 2, 0.075, 0.021]
        peg.addChild(label)

        // Interaction-ready components.
        peg.components.set(ChildTagComponent(childID: child.id))
        peg.components.set(InputTargetComponent())
        peg.components.set(HoverEffectComponent(.highlight(.init(color: .white, strength: 1.2))))

        // Phase E: VoiceOver announces each peg with the child + room and a hint.
        var a11y = AccessibilityComponent()
        a11y.isAccessibilityElement = true
        a11y.label = LocalizedStringResource("\(child.fullName), \(child.roomGroup)")
        a11y.value = "Double-tap to open today’s summary"
        a11y.traits = [.button]
        peg.components.set(a11y)

        peg.generateCollisionShapes(recursive: true)   // CollisionComponent for the whole peg
        return peg
    }

    private static func pegColor(_ i: Int) -> UIColor {
        let palette: [UIColor] = [.systemTeal, .systemPink, .systemOrange,
                                  .systemIndigo, .systemGreen]
        return palette[i % palette.count]
    }
}
