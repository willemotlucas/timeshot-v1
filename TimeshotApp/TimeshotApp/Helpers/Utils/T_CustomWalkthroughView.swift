//
//  T_CustomWalkthroughView.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 19/07/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import SwiftyWalkthrough

class T_CustomWalkthroughView: WalkthroughView {
    
    lazy var firstHelpLabel: UILabel = self.makeHelpLabel()
    lazy var secondHelpLabel: UILabel = self.makeHelpLabel()
    lazy var thirdHelpLabel: UILabel = self.makeHelpLabel()
    
    init() {
        super.init(frame: CGRectZero)
        
        addSubview(firstHelpLabel)
        addSubview(secondHelpLabel)
        addSubview(thirdHelpLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(firstHelpLabel)
        addSubview(secondHelpLabel)
        addSubview(thirdHelpLabel)
    }
    
    func makeHelpLabel() -> UILabel {
        let l = UILabel()
        l.textColor = UIColor.whiteColor()
        l.textAlignment = .Center
        l.numberOfLines = 0
        
        return l
    }
}