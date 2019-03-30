//
//  ViewController.swift
//  HapticTouch
//
//  Created by Allen on 3/29/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hapticFeedbackButton: UIButton!
    @IBOutlet weak var bpmSliderControl: UISlider!
    @IBOutlet weak var bpmNumberLabel: UILabel!

    let impactGenerator = UIImpactFeedbackGenerator.init(style: .heavy)
    var metronomeTimer = Timer()
    var metronomeRunningStatus = false {
        didSet {
            if metronomeRunningStatus == true {
                hapticFeedbackButton.setTitle("Stop", for: .normal)
            } else {
                hapticFeedbackButton.setTitle("Start", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bpmNumberLabel.text = "\(Int(bpmSliderControl.value))"
    }

    @IBAction func hapticFeedbackButton(_ sender: Any) {
        metronomeRunningStatus.toggle()
        switch metronomeRunningStatus {
        case true:
            startMetronomeTapping()
        case false:
            stopMetronomeTapping()
        }
    }

    func startMetronomeTapping() {
        let metronomeTimeInterval = Double(60.0 / bpmSliderControl.value)
        metronomeTimer = Timer.scheduledTimer(withTimeInterval: metronomeTimeInterval, repeats: true) { timer in
            self.impactGenerator.impactOccurred()
        }
        metronomeTimer.fire()
    }

    func stopMetronomeTapping() {
         metronomeRunningStatus = false
         metronomeTimer.invalidate()
    }

    @IBAction func bpmSliderValueChanged(_ sender: UISlider) {
        let currentMetronomeSpeed = Int(sender.value)
        bpmNumberLabel.text = "\(currentMetronomeSpeed)"
        stopMetronomeTapping()
    }
}

