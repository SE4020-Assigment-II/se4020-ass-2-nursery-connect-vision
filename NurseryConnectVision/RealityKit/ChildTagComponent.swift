//
//  ChildTagComponent.swift
//  NurseryConnectVision
//
//  Tags a peg entity with the child it represents, so a tap gesture (Phase D)
//  can resolve the model from the entity it hit.
//

import Foundation
import RealityKit

struct ChildTagComponent: Component {
    let childID: UUID
}
