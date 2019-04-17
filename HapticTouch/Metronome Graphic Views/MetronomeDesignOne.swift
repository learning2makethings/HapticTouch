//
//  MetronomeDesignOne.swift
//  HapticTouch
//
//  Created by Allen Wong on 4/10/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignOne: UIView, MetronomeDesignInterface {
    func metronomeClicked() {
        // just show number, do nothing
    }
    
    func metronomeBpmChanged(to bpm: Int) {
        bpmLabel.text = "\(bpm)"
    }
    
    func metronomeToggled(isRunning: Bool) {
        // isRunning is True, if metronome is turned on
        // otherwise False
        #warning("Implement metronome toggled")
    }
    
    func onFocus(metronome: Metronome) {
        bpmLabel.text = "\(metronome.bpm)"
    }
    
    @IBOutlet weak var bpmLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
    }
}
