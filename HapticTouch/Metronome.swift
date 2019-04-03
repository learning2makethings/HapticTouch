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
    private var metronomeTimer = Timer()
    
    
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
            let metronomeTimeInterval = 60.0 / Double(bpm)
            metronomeTimer = Timer.scheduledTimer(withTimeInterval: metronomeTimeInterval, repeats: true) { timer in
                playSound()
                 self.hapticFunction()
            }
            metronomeTimer.fire()
        }
    }
    
    func stop() {
        metronomeTimer.invalidate()
    }
    
    func setBPM(to value: Int) {
        bpm = value
    }
    
    func isRunning() -> Bool {
        return metronomeTimer.isValid
    }
}
