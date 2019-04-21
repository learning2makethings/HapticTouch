//
//  MetronomeDesignThree.swift
//  HapticTouch
//
//  Created by Julian Harper on 4/11/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignThree: UIView, MetronomeDesignInterface {

    //MARK: Declare variables for calls
    
    var metronomeImageArray = ["metronomeCenter", "metronomeLeft-1", "metronomeLeft-2", "metronomeLeft-3", "metronomeLeft-4", "metronomeLeft-5", "metronomeLeft-6", "metronomeLeft-7", "metronomeLeft-8", "metronomeLeft-7", "metronomeLeft-6", "metronomeLeft-5", "metronomeLeft-4", "metronomeLeft-3", "metronomeLeft-2", "metronomeLeft-1", "metronomeCenter", "metronomeRight-1", "metronomeRight-2", "metronomeRight-3", "metronomeRight-4", "metronomeRight-5", "metronomeRight-6", "metronomeRight-7", "metronomeRight-8", "metronomeRight-7", "metronomeRight-6", "metronomeRight-5", "metronomeRight-4", "metronomeRight-3", "metronomeRight-2", "metronomeRight-1"]
    
    var metronomeImages = [UIImage]()
    
    var metronomeAnimationDuration : Double = 1.2
    
    @IBOutlet weak var metronomeImageView: UIImageView!

    func animationMetronomeImages(){
        if metronomeImageView.isAnimating == false {
            metronomeImageView.startAnimating()
        } else{
            metronomeImageView.stopAnimating()
        }
    }

    
    //MARK: Class design inherited functions
    func metronomeClicked() {
        #warning("Implement metronome clicked")
        metronomeImageView.animationDuration = metronomeAnimationDuration
        animationMetronomeImages()

    }
    
    func metronomeBpmChanged(to bpm: Int) {
        #warning("Implement bpm changed")
        metronomeAnimationDuration = 60.0 / Double(bpm) / 0.5
        if metronomeImageView.isAnimating == true {
            metronomeImageView.startAnimating()
        }
        else{
        }
    }
    
    func metronomeToggled(isRunning: Bool) {
        // isRunning is True, if metronome is turned on
        // otherwise False
        #warning("Implement metronome toggled")
    }
    
    func onFocus(metronome: Metronome) {
        // this gets called when scrolling to page 3
        #warning("Implement onFocus")
        metronomeImageView.image = #imageLiteral(resourceName: "metronomeCenter.png")
        for i in 0..<metronomeImageArray.count{
            metronomeImages.append(UIImage(named: metronomeImageArray[i])!)
        }
        
        metronomeImageView.animationImages = metronomeImages
    }
    
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
