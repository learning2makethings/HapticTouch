//
//  MetronomeVC.swift
//  HapticTouch
//
//  Created by Allen on 3/29/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

class MetronomeVC: UIViewController {

    @IBOutlet weak var hapticFeedbackButton: UIButton!
    @IBOutlet weak var bpmSliderControl: UISlider!
    @IBOutlet weak var bpmNumberLabel: UILabel!
    
    let startString = NSLocalizedString("startMetronome", comment: "Start metronome")
    let stopString = NSLocalizedString("stopMetronome", comment: "Stop metronome")
    
    // check if device is an iPhone 6 or iPhone 6s (no support for impact generator)
    // iPhone 6 models begin with string iPhone8
    let metronome = Metronome(bpm: 60, supportsImpactGenerator: !UIDevice.current.modelName.starts(with: "iPhone8"))
    
    var metronomeRunningStatus = false {
        didSet {
            if metronome.isRunning() == true {
                hapticFeedbackButton.setTitle(stopString, for: .normal)
            } else {
                hapticFeedbackButton.setTitle(startString, for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        metronomeRunningStatus = false
        
        let value = Int(bpmSliderControl.value)
        bpmNumberLabel.text = "\(value)"
        metronome.setBPM(to: value)
    }

    @IBAction func hapticFeedbackButton(_ sender: Any) {
        metronome.toggle()
        metronomeRunningStatus = metronome.isRunning()
    }
    
    func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    @IBAction func bpmSliderValueChanged(_ sender: UISlider) {
        metronome.stop()
        metronomeRunningStatus = false
        
        let currentMetronomeSpeed = Int(sender.value)
        bpmNumberLabel.text = "\(currentMetronomeSpeed)"
        metronome.setBPM(to: currentMetronomeSpeed)
        
    }
}

