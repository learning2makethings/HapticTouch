//
//  InterfaceController.swift
//  HapticTouch WatchKit Extension
//
//  Created by Allen on 3/29/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var hapticFeedbackButton: WKInterfaceButton!
    @IBOutlet weak var bpmPickerControl: WKInterfacePicker!

    var currentMetronomeSpeed = 100
    var metronomeTimer = Timer()
    var metronomeRunningStatus = false {
        didSet {
            if metronomeRunningStatus == true {
                hapticFeedbackButton.setTitle("Stop")
            } else {
                hapticFeedbackButton.setTitle("Start")
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        setupPickerWheel()


    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func setupPickerWheel() {
        var bpmRanges = [WKPickerItem]()
        let bpmNumbers = Array(40...198)
        for number in bpmNumbers {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(number)"
            bpmRanges.append(pickerItem)
        }

        bpmPickerControl.setItems(bpmRanges)
        bpmPickerControl.setSelectedItemIndex(60)
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
        let metronomeTimeInterval = Double(60.0 / Double(currentMetronomeSpeed))
        metronomeTimer = Timer.scheduledTimer(withTimeInterval: metronomeTimeInterval, repeats: true) { timer in
            WKInterfaceDevice.current().play(.click)
        }
        metronomeTimer.fire()
    }

    func stopMetronomeTapping() {
        metronomeRunningStatus = false
        metronomeTimer.invalidate()
    }

    @IBAction func bpmPickerControl(_ value: Int) {
        currentMetronomeSpeed = Int(value)
        stopMetronomeTapping()
    }
}
