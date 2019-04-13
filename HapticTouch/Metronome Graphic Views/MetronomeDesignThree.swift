//
//  MetronomeDesignThree.swift
//  HapticTouch
//
//  Created by Julian Harper on 4/11/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit
import SpriteKit

class MetronomeDesignThree: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let scene = SKScene(size: SKView.layoutFittingExpandedSize)
    
    let image = SKSpriteNode(imageNamed:"metronomeCenter.png")
    
 //   let metronomeArray: UIImage = [metronomeMovie]
    
    @IBOutlet weak var metronome: UIImageView!
    

    
//    func metronomeMovie(){
//        metronomeArray.animationImages
//    }
//
    
}
