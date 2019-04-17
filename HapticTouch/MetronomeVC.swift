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
    
    
    var metronomeDesigns = [MetronomeDesignInterface]()
    
    let metronome = Metronome(bpm: 60, supportsImpactGenerator: !UIDevice.current.modelName.starts(with: "iPhone8"))
    var metronomeRunningStatus = false {
        didSet {
            metronomeDesigns[metronomeDesignsPageControl.currentPage].metronomeToggled(isRunning: metronome.isRunning())
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
        
        // notifications that are sent to the views
        NotificationCenter.default.addObserver(self, selector: #selector(metronomeTickNotification), name: Metronome.tickNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(metronomeBpmChangeNotification), name: Metronome.bpmChangeNotificaiton, object: nil)
        
        // setup pages
        metronomeDesignsScrollView.delegate = self
        metronomeGraphicsSetup()
        metronomeGraphicPageControlSetup()
        
        // setup metronome
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
    
    @objc func metronomeTickNotification() {
        metronomeDesigns[metronomeDesignsPageControl.currentPage].metronomeClicked()
    }
    
    @objc func metronomeBpmChangeNotification(_ notification: NSNotification) {
        
        let bpm = notification.userInfo!["bpm"] as! Int
        metronomeDesigns[metronomeDesignsPageControl.currentPage].metronomeBpmChanged(to: bpm)
        
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
    
    // do we need this?
    func currentDesign() -> MetronomeDesign {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        let currentView = metronomeDesigns[pageIndex]
        if currentView.isKind(of: MetronomeDesignOne.self) {
            return .designOne
        } else if currentView.isKind(of: MetronomeDesignTwo.self) {
            return .designTwo
        } else{
            return .designThree
        }
    }

    func setupScrollView(metronomeStyles: [UIView]) {
        metronomeDesignsScrollView.contentSize = CGSize(width: scrollViewContainerView.frame.width * CGFloat(metronomeStyles.count), height: 0)
        metronomeDesignsScrollView.isPagingEnabled = true

        for design in 0 ..< metronomeStyles.count {
            metronomeStyles[design].frame = CGRect(x: scrollViewContainerView.frame.width * CGFloat(design), y: 0, width: scrollViewContainerView.frame.width, height: scrollViewContainerView.frame.height)
            metronomeDesignsScrollView.addSubview(metronomeStyles[design])
        }
    }

    // Load your design by changing to the relative nib name you created
    // Add it to the array returned below
    func createMetronomeDesigns() -> [MetronomeDesignInterface] {
        let viewOne = Bundle.main.loadNibNamed("MetronomeDesignOne", owner: self, options: nil)?.first as! MetronomeDesignOne
        viewOne.backgroundColor = UIColor.cyan
        print("XXX: \(viewOne.frame)")
        
        let viewTwo = Bundle.main.loadNibNamed("MetronomeDesignTwo", owner: self, options: nil)?.first as! MetronomeDesignTwo
        viewTwo.flashingView.backgroundColor = .lightGray
        
        let viewThree = Bundle.main.loadNibNamed("MetronomeDesignThree", owner: self, options: nil)?.first as! MetronomeDesignThree
        viewThree.backgroundColor = UIColor.gray

        return [viewOne, viewTwo, viewThree]
    }

    //MARK: - Metronome Animation
    @objc func metronomeImageView(){
        if currentDesign() == .designThree {
            let currentView = metronomeDesigns[2] as! MetronomeDesignThree
            if currentView.metronomeImageView.isAnimating == false {
                currentView.metronomeImageView.startAnimating()
            }else {
                currentView.metronomeImageView.stopAnimating()
            }
        }
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(metronomeDesignsScrollView.contentOffset.x / view.frame.width))
        print(pageIndex)
        
        if pageIndex != metronomeDesignsPageControl.currentPage {
            metronomeDesignsPageControl.currentPage = pageIndex
            metronomeDesigns[pageIndex].onFocus(metronome: metronome)
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
    case designThree
}
