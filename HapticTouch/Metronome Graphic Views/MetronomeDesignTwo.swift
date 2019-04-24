//
//  MetronomeDesignTwo.swift
//  HapticTouch
//
//  Created by Allen Wong on 4/10/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignTwo: UIView, MetronomeDesignInterface {
    func metronomeClicked() {
//        if flashingView.backgroundColor == UIColor.lightGray {
//            flashingView.backgroundColor = UIColor.black
//        } else {
//            flashingView.backgroundColor = UIColor.lightGray
//        }
        
        flashingView.backgroundColor = UIColor.black
        UIView.animate(
            withDuration: flashDuration,
            delay: 0.0,
            options: .allowUserInteraction,
            animations: {
                self.flashingView.backgroundColor = .lightGray
        })
    }
    
    func metronomeBpmChanged(to bpm: Int) {
        flashDuration = 60.0 / Double(bpm) / 2.0
    }
    
    func metronomeToggled(isRunning: Bool) {
        // isRunning is True, if metronome is turned on
        // otherwise False
    }
    
    func onFocus(metronome: Metronome) {
        // nothing to do (yet)
    }
    
    var flashDuration = 0.4
    @IBOutlet weak var flashingView: UIView!

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
