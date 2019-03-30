//
//  ViewController.swift
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

class ViewController: UIViewController {

    @IBOutlet weak var hapticFeedbackButton: UIButton!
    @IBOutlet weak var bpmSliderControl: UISlider!
    @IBOutlet weak var bpmNumberLabel: UILabel!
    
    // check if device is an iPhone 6 or iPhone 6s (no support for impact generator)
    let hapticFunction = (UIDevice.current.modelName.starts(with: "iPhone8") ? timerActionFallback : timerAction)

    static let impactGenerator = UIImpactFeedbackGenerator.init(style: .heavy)
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
    
    static func timerAction() {
        impactGenerator.impactOccurred()
    }
    
    static func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    func startMetronomeTapping() {
        let metronomeTimeInterval = Double(60.0 / bpmSliderControl.value)
        metronomeTimer = Timer.scheduledTimer(withTimeInterval: metronomeTimeInterval, repeats: true) { timer in
            self.hapticFunction()
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

