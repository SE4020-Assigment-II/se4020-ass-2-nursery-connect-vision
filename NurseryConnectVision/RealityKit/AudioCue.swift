//
//  AudioCue.swift
//  NurseryConnectVision
//
//  Loads the confirmation chime once and plays it spatially from a tapped peg.
//  No-ops gracefully if `chime.wav` is not in the app target, so taps still
//  work without sound.
//

import RealityKit
import Foundation

@MainActor
enum AudioCue {
    private static var resource: AudioFileResource? = {
        try? AudioFileResource.load(named: "chime.wav",
                                    configuration: .init(shouldLoop: false))
    }()

    /// Plays the chime spatially from `entity`. No-op if the asset is missing.
    static func playChime(from entity: Entity) {
        guard let resource else { return }
        // SpatialAudioComponent makes the sound emanate from the entity's position.
        if entity.components[SpatialAudioComponent.self] == nil {
            entity.components.set(SpatialAudioComponent())
        }
        entity.playAudio(resource)
    }
}
