//
//  MetronomeDesignThree.swift
//  HapticTouch
//
//  Created by Julian Harper on 4/11/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignThree: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var metronomeImages = [UIImage]()
    
    let metronomeImageArray = ["metronomeCenter", "metronomLeft-1", "metronomLeft-2", "metronomLeft-3", "metronomLeft-4", "metronomLeft-5", "metronomLeft-6", "metronomLeft-7", "metronomLeft-8", "metronomLeft-7", "metronomLeft-6", "metronomLeft-5", "metronomLeft-4", "metronomLeft-3", "metronomLeft-2", "metronomLeft-1", "metronomeCenter", "metronomRight-1", "metronomRight-2", "metronomRight-3", "metronomRight-4", "metronomRight-5", "metronomRight-6", "metronomRight-7", "metronomRight-8", "metronomRight-7", "metronomRight-6", "metronomRight-5", "metronomRight-4", "metronomRight-3", "metronomRight-2", "metronomRight-1"]
    

    
    @IBOutlet weak var metronome: UIImageView!
    
    @IBAction func startButtonPressed(_ sender: Any) {
        aninmateMetronomeImages()
    }
    func aninmateMetronomeImages(){
        for i in 0..<metronomeImageArray.count{
            metronomeImages.append(UIImage(named: metronomeImageArray[i])!)
        }
        
        metronome.animationImages = metronomeImages
        metronome.startAnimating()
    }

}
