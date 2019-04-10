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
    @IBOutlet weak var metronomeDesignsScrollView: UIScrollView!
    @IBOutlet weak var metronomeDesignsPageControl: UIPageControl!
    @IBOutlet weak var hapticFeedbackButton: UIButton!
    @IBOutlet weak var bpmSliderControl: UISlider!

    // MARK: - Properties
    let startString = NSLocalizedString("startMetronome", comment: "Start metronome")
    let stopString = NSLocalizedString("stopMetronome", comment: "Stop metronome")
    var metronomeDesigns = [UIView]()
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
        metronomeDesignsScrollView.delegate = self
        metronomeGraphicsSetup()
        metronomeGraphicPageControlSetup()
        metronomeRunningStatus = false
        let value = Int(bpmSliderControl.value)
        metronome.setBPM(to: value)
        updateFieldsInMetronomeDesignOne(bpm: "\(value)")
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
        metronomeDesignsScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(createMetronomeDesigns().count), height: metronomeDesignsScrollView.frame.height)
        metronomeDesignsScrollView.isPagingEnabled = true

        for design in 0 ..< metronomeStyles.count {
            metronomeStyles[design].frame = CGRect(x: view.frame.width * CGFloat(design), y: 0, width: view.frame.width, height: metronomeDesignsScrollView.frame.height)
            metronomeDesignsScrollView.addSubview(metronomeStyles[design])
        }
    }

    // MARK: - Actions
    @IBAction func hapticFeedbackButton(_ sender: Any) {
        metronome.toggle()
        metronomeRunningStatus = metronome.isRunning()
    }

    @IBAction func minusButtonPressed(_ sender: Any) {
        //write if statement to lower slider control
        var value = Int(bpmSliderControl.value)
        if value > 40 {
            value -= 1
            updateFieldsInMetronomeDesignOne(bpm: "\(value)")
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }

    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        //write if statement to raise slider control
        var value = Int(bpmSliderControl.value)
        if value < 218 {
            value += 1
            updateFieldsInMetronomeDesignOne(bpm: "\(value)")
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }
    }
    
    @IBAction func bpmSliderValueChanged(_ sender: UISlider) {
        let currentMetronomeSpeed = Int(sender.value)
        metronome.setBPM(to: currentMetronomeSpeed)
        updateFieldsInMetronomeDesignOne(bpm: "\(currentMetronomeSpeed)")
    }

    // MARK: - Functions (Better name for this mark?)
    func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    // Example of how to access properties of the currently selected Metronome Design in the scrollview
    func updateFieldsInMetronomeDesignOne(bpm: String) {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        metronomeDesignsPageControl.currentPage = pageIndex
        let currentView = metronomeDesigns[pageIndex]
        if currentView.isKind(of: MetronomeDesignOne.self) {
            let currentPageIndex = metronomeDesignsPageControl.currentPage
            let currentlySelectedDesign = metronomeDesigns[currentPageIndex] as! MetronomeDesignOne
            currentlySelectedDesign.bpmLabel.text = bpm
        }
    }

    func syncBpmNumberBetweenViews() {
        let currentMetronomeSpeed = Int(bpmSliderControl.value)
        updateFieldsInMetronomeDesignOne(bpm: "\(currentMetronomeSpeed)")
    }

    // Load your design by changing to the relative nib name you created
    // Add it to the array returned below
    func createMetronomeDesigns() -> [UIView] {
        let viewOne = Bundle.main.loadNibNamed("MetronomeDesignOne", owner: self, options: nil)?.first as! MetronomeDesignOne
        viewOne.backgroundColor = UIColor.red

        let viewTwo = Bundle.main.loadNibNamed("MetronomeDesignTwo", owner: self, options: nil)?.first as! MetronomeDesignTwo
        viewTwo.backgroundColor = UIColor.blue

        let viewThree = Bundle.main.loadNibNamed("MetronomeDesignOne", owner: self, options: nil)?.first as! MetronomeDesignOne
        viewThree.backgroundColor = UIColor.gray

        return [viewOne, viewTwo, viewThree]
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        metronomeDesignsPageControl.currentPage = pageIndex
        let currentView = metronomeDesigns[pageIndex]
        if currentView.isKind(of: MetronomeDesignOne.self) {
            syncBpmNumberBetweenViews()
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
