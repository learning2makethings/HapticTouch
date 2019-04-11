//
//  MetronomeVC.swift
//  HapticTouch
//
//  Created by Allen on 3/29/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit
import AudioToolbox

class MetronomeVC: UIViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var scrollViewContainerView: UIView!
    @IBOutlet weak var metronomeDesignsScrollView: UIScrollView!
    @IBOutlet weak var metronomeDesignsPageControl: UIPageControl!
    @IBOutlet weak var hapticFeedbackButton: UIButton!
    @IBOutlet weak var bpmSliderControl: UISlider!

    // MARK: - Properties
    let startString = NSLocalizedString("startMetronome", comment: "Start metronome")
    let stopString = NSLocalizedString("stopMetronome", comment: "Stop metronome")
    var metronomeDesigns = [UIView]()
    var currentBpm = 100
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

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMetronomeTickNotification()
        setupMetronomeBpmNotification()
        metronomeDesignsScrollView.delegate = self
        metronomeGraphicsSetup()
        metronomeGraphicPageControlSetup()
        metronomeRunningStatus = false
        let value = Int(bpmSliderControl.value)
        metronome.setBPM(to: value)

    }

    // MARK: - Setup Functions
    func metronomeGraphicsSetup() {
        metronomeDesigns = createMetronomeDesigns()
        setupScrollView(metronomeStyles: metronomeDesigns)
        view.bringSubviewToFront(metronomeDesignsPageControl)
    }

    func metronomeGraphicPageControlSetup() {
        metronomeDesignsPageControl.numberOfPages = metronomeDesigns.count
        metronomeDesignsPageControl.currentPage = 0
    }

    func setupScrollView(metronomeStyles: [UIView]) {
        metronomeDesignsScrollView.contentSize = CGSize(width: scrollViewContainerView.frame.width * CGFloat(createMetronomeDesigns().count), height: metronomeDesignsScrollView.frame.height)
        metronomeDesignsScrollView.isPagingEnabled = true

        for design in 0 ..< metronomeStyles.count {

            metronomeStyles[design].frame = CGRect(x: scrollViewContainerView.frame.width * CGFloat(design), y: 0, width: scrollViewContainerView.frame.width, height: metronomeDesignsScrollView.frame.height)
            metronomeDesignsScrollView.addSubview(metronomeStyles[design])
        }
    }

    func setupMetronomeTickNotification() {
        let metronomeTicked = Notification.Name("metronomeTicked")
        NotificationCenter.default.addObserver(self, selector: #selector(flashView), name: metronomeTicked, object: nil)
    }

    func setupMetronomeBpmNotification() {
        let notificationName = Notification.Name("metronomeBpm")
        NotificationCenter.default.addObserver(self, selector: #selector(updateBpmValue), name: notificationName, object: nil)
    }

    // MARK: - Actions
    @IBAction func hapticFeedbackButton(_ sender: Any) {
        metronome.toggle()
        metronomeRunningStatus = metronome.isRunning()
    }

    @IBAction func minusButtonPressed(_ sender: Any) {
        var value = Int(bpmSliderControl.value)
        if value > 40 {
            value -= 1
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        var value = Int(bpmSliderControl.value)
        if value < 218 {
            value += 1
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }
    }
    
    @IBAction func bpmSliderValueChanged(_ sender: UISlider) {
        let currentMetronomeSpeed = Int(sender.value)
        metronome.setBPM(to: currentMetronomeSpeed)
    }

    // MARK: - Functions (Better name for this mark?)
    func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    // Add a function here to update your Metronome Designs BPM label if applicable
    func updateBpmLabel() {
        if currentDesign() == .designOne {
            updateFieldsInMetronomeDesignOne(bpm: "\(currentBpm)")
        }
    }

    // Example of how to access properties of the currently selected Metronome Design in the scrollview
    func updateFieldsInMetronomeDesignOne(bpm: String) {
        if currentDesign() == .designOne {
            let currentPageIndex = metronomeDesignsPageControl.currentPage
            let currentlySelectedDesign = metronomeDesigns[currentPageIndex] as! MetronomeDesignOne
            currentlySelectedDesign.bpmLabel.text = bpm
        }
    }

    func currentDesign() -> MetronomeDesign {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        let currentView = metronomeDesigns[pageIndex]
        if currentView.isKind(of: MetronomeDesignOne.self) {
            return .designOne
        } else if currentView.isKind(of: MetronomeDesignTwo.self) {
            return .designTwo
        } else {
            return .designOne
        }
    }

    // Load your design by changing to the relative nib name you created
    // Add it to the array returned below
    func createMetronomeDesigns() -> [UIView] {
        let viewOne = Bundle.main.loadNibNamed("MetronomeDesignOne", owner: self, options: nil)?.first as! MetronomeDesignOne
        viewOne.backgroundColor = UIColor.red

        let viewTwo = Bundle.main.loadNibNamed("MetronomeDesignTwo", owner: self, options: nil)?.first as! MetronomeDesignTwo
        viewTwo.flashingView.backgroundColor = .lightGray
        let viewThree = Bundle.main.loadNibNamed("MetronomeDesignOne", owner: self, options: nil)?.first as! MetronomeDesignOne
        viewThree.backgroundColor = UIColor.gray

        return [viewOne, viewTwo, viewThree]
    }

    @objc func flashView() {
        if currentDesign() == .designTwo {
            let currentView = metronomeDesigns[1] as! MetronomeDesignTwo
            if currentView.flashingView.backgroundColor == UIColor.lightGray {
                currentView.flashingView.backgroundColor = UIColor.black
            } else {
                currentView.flashingView.backgroundColor = UIColor.lightGray
            }
        }
    }

    @objc func updateBpmValue(_ notification: Notification) {
         if let data = notification.userInfo as? [String: Int] {
            guard let bpm = data.first else { return }
            currentBpm = bpm.value
            // Any views that need to update a bpm label should add it to this function
            updateBpmLabel()
        }
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        metronomeDesignsPageControl.currentPage = pageIndex
        // Check what Design is being scrolled too and update any needed info
        if currentDesign() == .designOne {
            updateBpmLabel()
        }
    }
}

// MARK: - Extensions
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

// MARK: - Enums
enum MetronomeDesign {
    case designOne
    case designTwo
}
