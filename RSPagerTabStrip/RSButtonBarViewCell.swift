//
//  RSButtonBarViewCell.swift
//  RSPagerTabStrip
//
//  Created by UGolf_Reese on 15/4/28.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

class RSButtonBarViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    var hightlightColor: UIColor = UIColor.blueColor()
    
    override var selected: Bool {
        didSet {
            if selected {
                self.label.textColor = self.hightlightColor
            }else {
                self.label.textColor = UIColor.blackColor()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initButtonBarViewCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initButtonBarViewCell()
    }
    
    private func initButtonBarViewCell() {
        
        if self.label == nil {
            self.label = UILabel()
            self.contentView.addSubview(self.label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.center = CGPoint(x: self.contentView.frame.width/2, y: self.contentView.frame.height/2)
    }
    

}
