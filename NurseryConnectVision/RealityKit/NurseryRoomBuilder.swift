//
//  NurseryRoomBuilder.swift
//  NurseryConnectVision
//
//  Builds the bounded nursery-room scene entirely in code (no Reality Composer
//  Pro): floor + two low walls + a row of coloured "pegs", one per child, each
//  with a floating name plate. Every peg is interaction-ready (tag, input
//  target, hover, collision) so Phase D can wire taps without rebuilding.
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
        root.addChild(makeWall(width: 0.6, at: [0, 0.06, -0.3]))                 // back wall
        root.addChild(makeWall(width: 0.6, at: [-0.3, 0.06, 0]).rotatedY(.pi / 2)) // left wall

        // Row of pegs along the back, evenly spaced and centred.
        let spacing: Float = 0.11
        let startX = -spacing * Float(children.count - 1) / 2
        for (i, child) in children.enumerated() {
            let peg = makePeg(for: child, index: i)
            peg.position = [startX + spacing * Float(i), 0.10, -0.22]
            root.addChild(peg)
        }
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

    private static func makeWall(width: Float, at position: SIMD3<Float>) -> Entity {
        let mesh = MeshResource.generateBox(width: width, height: 0.12, depth: 0.01,
                                            cornerRadius: 0.004)
        let mat  = SimpleMaterial(color: .init(white: 0.92, alpha: 1), isMetallic: false)
        let wall = ModelEntity(mesh: mesh, materials: [mat])
        wall.position = position
        return wall
    }

    /// A coloured locker box + floating name label, fully tap-ready.
    private static func makePeg(for child: Child, index: Int) -> Entity {
        let peg = Entity()
        peg.name = "Peg-\(child.id.uuidString)"

        let box = ModelEntity(
            mesh: .generateBox(width: 0.08, height: 0.10, depth: 0.04, cornerRadius: 0.012),
            materials: [SimpleMaterial(color: pegColor(index), isMetallic: false)]
        )
        peg.addChild(box)

        // Floating name plate above the locker.
        let label = ModelEntity(
            mesh: .generateText(child.pegLabel,
                                extrusionDepth: 0.001,
                                font: .systemFont(ofSize: 0.018),
                                alignment: .center),
            materials: [UnlitMaterial(color: .white)]
        )
        label.position = [-0.03, 0.07, 0.021]
        peg.addChild(label)

        // Interaction-ready components.
        peg.components.set(ChildTagComponent(childID: child.id))
        peg.components.set(InputTargetComponent())
        peg.components.set(HoverEffectComponent())
        peg.generateCollisionShapes(recursive: true)   // CollisionComponent for the whole peg

        return peg
    }

    private static func pegColor(_ i: Int) -> UIColor {
        let palette: [UIColor] = [.systemTeal, .systemPink, .systemOrange,
                                  .systemIndigo, .systemGreen]
        return palette[i % palette.count]
    }
}

private extension Entity {
    /// Returns self after rotating about the Y axis (chaining helper).
    func rotatedY(_ radians: Float) -> Entity {
        orientation = simd_quatf(angle: radians, axis: [0, 1, 0])
        return self
    }
}
