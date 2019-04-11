//
//  MetronomeDesignTwo.swift
//  HapticTouch
//
//  Created by Allen Wong on 4/10/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import UIKit

class MetronomeDesignTwo: UIView {
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
        self.isOpaque = true
        self.alpha = 0.7
    }
}
