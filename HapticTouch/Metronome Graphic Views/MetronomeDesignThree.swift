//
//  MetronomeDesignThree.swift
//  HapticTouch
//
//  Created by Julian Harper on 4/11/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignThree: UIView {
    
    @IBOutlet weak var metronomeImageView: UIImageView!
    
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

    var metronomeImageArray = ["metronomeCenter", "metronomeLeft-1", "metronomeLeft-2", "metronomeLeft-3", "metronomeLeft-4", "metronomeLeft-5", "metronomeLeft-6", "metronomeLeft-7", "metronomeLeft-8", "metronomeLeft-7", "metronomeLeft-6", "metronomeLeft-5", "metronomeLeft-4", "metronomeLeft-3", "metronomeLeft-2", "metronomeLeft-1", "metronomeCenter", "metronomeRight-1", "metronomeRight-2", "metronomeRight-3", "metronomeRight-4", "metronomeRight-5", "metronomeRight-6", "metronomeRight-7", "metronomeRight-8", "metronomeRight-7", "metronomeRight-6", "metronomeRight-5", "metronomeRight-4", "metronomeRight-3", "metronomeRight-2", "metronomeRight-1"]
    
    var metronomeImages = [UIImage]()
    

    
    
  @IBAction func startButtonPressed(_ sender: Any) {
    if metronomeImageView.isAnimating == false{
       startAninmateMetronomeImages()
    }
    else {
        metronomeImageView.stopAnimating()
        }
    }

    func startAninmateMetronomeImages(){
        
        
        for i in 0..<metronomeImageArray.count{
            metronomeImages.append(UIImage(named: metronomeImageArray[i])!)
        }
        
        metronomeImageView.animationImages = metronomeImages
        metronomeImageView.animationDuration = 1.0
        metronomeImageView.startAnimating()
    }
    
    func animateMetronomeImages(){
        
    }

}


/* class MetronomeDesignTwo: UIView {
    @IBOutlet weak var flashingView: UIView!
    
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
*/
