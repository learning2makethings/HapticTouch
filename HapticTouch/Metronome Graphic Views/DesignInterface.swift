//
//  DesignInterface.swift
//  HapticTouch
//
//  Created by Felix Fritz on 17.04.19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

protocol MetronomeDesignInterface: UIView {
    func metronomeClicked()
    func metronomeBpmChanged(to bpm: Int)
    func metronomeToggled(isRunning: Bool)
    
    // when scrolling to corresponding design, do necessary
    // setup (update values, start animation, ...)
    func onFocus(metronome: Metronome)
}
