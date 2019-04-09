//
//  Metronome.swift
//  HapticTouch
//
//  Created by Felix Fritz on 03.04.19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

// import Foundation
import UIKit
import AudioToolbox

class Metronome {

    // beats per minute
    var bpm: Int

    // iPhone 7 and up use func timerAction, iPhone 6s the fallback
    private var hapticFunction: () -> () = {}
    private let impactGenerator = UIImpactFeedbackGenerator.init(style: .heavy)
    private var isBeating = false
    var metronomeTimer = Timer()

    init(bpm: Int, supportsImpactGenerator: Bool) {
        self.bpm = bpm
        self.hapticFunction = (supportsImpactGenerator) ? timerAction : timerActionFallback
    }

    private func timerAction() {
        impactGenerator.impactOccurred()
    }

    private func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    func toggle() {
        if isRunning() {
            stop()
        } else {
            start()
        }
    }

    func start() {
        if !isRunning() {
            isBeating = true
            beatWithSpeed(speed: bpm)
        }
    }

    @objc func beatWithSpeed(speed: Int) {
        let timeInterval = 60.0 / Double(bpm)
        let date = Date().addingTimeInterval(timeInterval)
        metronomeTimer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(playMetronomeTick), userInfo: nil, repeats: false)
        RunLoop.main.add(metronomeTimer, forMode: .common)
    }

    @objc func playMetronomeTick() {
        playSound()
        self.hapticFunction()
        beatWithSpeed(speed: bpm)
    }

    func stop() {
        metronomeTimer.invalidate()
        isBeating = false
    }

    func setBPM(to value: Int) {
        bpm = value
    }

    func isRunning() -> Bool {
        return isBeating
    }
}
