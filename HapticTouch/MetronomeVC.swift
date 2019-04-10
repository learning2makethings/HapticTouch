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
    @IBOutlet weak var bpmNumberLabel: UILabel!

    // MARK: - Properties
    let startString = NSLocalizedString("startMetronome", comment: "Start metronome")
    let stopString = NSLocalizedString("stopMetronome", comment: "Stop metronome")
    var metronomeDesigns = [MetronomeDesign]()
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
        bpmNumberLabel.text = "\(value)"
        metronome.setBPM(to: value)
        updateFieldsInMetronomeGraphicView(bpm: "\(value)")
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

    func setupScrollView(metronomeStyles: [MetronomeDesign]) {
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
            bpmNumberLabel.text = "\(value)"
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }

    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        //write if statement to raise slider control
        var value = Int(bpmSliderControl.value)
        if value < 218 {
            value += 1
            bpmNumberLabel.text = "\(value)"
            metronome.setBPM(to: value)
            bpmSliderControl.setValue(Float(value), animated: true)
        }
    }
    
    @IBAction func bpmSliderValueChanged(_ sender: UISlider) {
        let currentMetronomeSpeed = Int(sender.value)
        bpmNumberLabel.text = "\(currentMetronomeSpeed)"
        metronome.setBPM(to: currentMetronomeSpeed)
        updateFieldsInMetronomeGraphicView(bpm: "\(currentMetronomeSpeed)")

    }

    // MARK: - Functions (Better name for this mark?)
    func timerActionFallback() {
        AudioServicesPlaySystemSound(1520)
    }

    // Example of how to access properties of the currently selected Metronome Design in the scrollview
    func updateFieldsInMetronomeGraphicView(bpm: String) {
        let currentPageIndex = metronomeDesignsPageControl.currentPage
        let currentlySelectedDesign = metronomeDesigns[currentPageIndex]
        currentlySelectedDesign.bpmLabel.text = bpm
    }

    // Load your design by changing to the relative nib name you created
    // Add it to the array returned below
    func createMetronomeDesigns() -> [MetronomeDesign] {
        let viewOne = Bundle.main.loadNibNamed("MetronomeDesign", owner: self, options: nil)?.first as! MetronomeDesign
        viewOne.viewLabel.text = "View 1"
        viewOne.backgroundColor = UIColor.red

        let viewTwo = Bundle.main.loadNibNamed("MetronomeDesign", owner: self, options: nil)?.first as! MetronomeDesign
        viewTwo.backgroundColor = UIColor.blue
        viewTwo.viewLabel.text = "View 2"

        let viewThree = Bundle.main.loadNibNamed("MetronomeDesign", owner: self, options: nil)?.first as! MetronomeDesign
        viewThree.viewLabel.text = "View 3"
        viewThree.backgroundColor = UIColor.gray

        return [viewOne, viewTwo, viewThree]
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        metronomeDesignsPageControl.currentPage = pageIndex
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
