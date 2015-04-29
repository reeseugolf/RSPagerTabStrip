//
//  RSButtonBarView.swift
//  RSPagerTabStrip
//
//  Created by UGolf_Reese on 15/4/28.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

let _TabBarHeight: CGFloat = 44.0

class RSButtonBarView: UICollectionView {

    var indexView: UIView!
    var indicateView: UIView!
    
    var leftRightMargin: CGFloat = 8
    
    var labelFont: UIFont = UIFont.systemFontOfSize(14.0)
    var labelHightlightColor: UIColor = UIColor.blueColor() {
        didSet {
            self.indicateView.backgroundColor = labelHightlightColor
        }
    }
    
    var isSkipViewControllers: Bool = false
    
    private var zoom: CGFloat = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        self.initializerButtonBarView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.calculationTabBarViewZoom()
        self.sendSubviewToBack(self.indexView)
    }
    
    override func reloadData() {
        super.reloadData()
        self.sendSubviewToBack(self.indexView)
    }
    
    
    
    private func initializerButtonBarView() {
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSize(width: 44, height: 44)
        self.backgroundColor = UIColor.whiteColor()
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth

        if self.indexView == nil {
            self.indexView = UIView()
            self.indexView.frame = CGRect(x: 0, y: 0, width: 44, height: self.frame.height)
            self.insertSubview(self.indexView, atIndex: 0)
        }
        self.indexView.backgroundColor = UIColor.clearColor()
        
        if self.indicateView == nil {
            self.indicateView = UIView()
            self.indicateView.frame = CGRect(x: self.leftRightMargin, y: CGRectGetHeight(self.indexView.frame)-3, width: CGRectGetWidth(self.indexView.frame)-self.leftRightMargin*2, height: 3)
            self.indexView.addSubview(self.indicateView)
        }
        self.indicateView.backgroundColor = self.labelHightlightColor
        self.indicateView.autoresizingMask = UIViewAutoresizing.FlexibleWidth

    }
    
    
    
    
    
    
    // MARK: - Publish Methods
    
    func moveToIndex(toIndex: Int, fromIndex: Int) -> Void {
        let toFrame = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: toIndex, inSection: 0))!.frame
        var contentOffset: CGFloat = 0
        if self.contentOffset.x > toFrame.origin.x {
            contentOffset = self.contentOffset.x - toFrame.origin.x
        }
        else if (toFrame.origin.x + toFrame.size.width) > (self.contentOffset.x + self.frame.width) {
            contentOffset = (self.contentOffset.x + self.frame.width) - (toFrame.origin.x + toFrame.size.width)
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.indexView.frame = toFrame
            self.contentOffset = CGPoint(x: self.contentOffset.x - contentOffset, y: 0)
        }) { (Bool) -> Void in
            self.isSkipViewControllers = false
        }

    }
    
    func moveToIndex(toIndex: Int, fromIndex: Int, withProgressPercentage progressPercentage: CGFloat) -> Void {
        
        let fromFrame = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: fromIndex, inSection: 0))!.frame
        let toFrame = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: toIndex, inSection: 0))!.frame
        let itemSpancing = fabs(fromFrame.origin.x - toFrame.origin.x)
        
        if !self.isSkipViewControllers {
            var indexframe = self.indexView.frame
            indexframe.size.width = fromFrame.width - (fromFrame.width - toFrame.width) * fabs(progressPercentage)
            indexframe.origin.x = (fromFrame.origin.x * self.zoom + itemSpancing * self.zoom * progressPercentage)
            
            let tabBarOffset = indexframe.origin.x / self.zoom - indexframe.origin.x
            self.contentOffset = CGPoint(x: tabBarOffset, y: 0)
            
            indexframe.origin.x += tabBarOffset
            self.indexView.frame = indexframe
        }
        else {

            var indexframe = self.indexView.frame
            indexframe.size.width = fromFrame.width - (fromFrame.size.width - toFrame.size.width) * fabs(progressPercentage)
            indexframe.origin.x = fromFrame.origin.x * self.zoom + itemSpancing * self.zoom * progressPercentage
            
            let tabBarOffset = indexframe.origin.x / self.zoom - indexframe.origin.x
            self.contentOffset = CGPoint(x: tabBarOffset, y: 0)
            
            indexframe.origin.x += tabBarOffset
            self.indexView.frame = indexframe
            
        }
    }
    
    func calculationTabBarViewZoom() -> Void {
        
        let contentSize = self.collectionViewLayout.collectionViewContentSize()
        let numberOfItems = self.numberOfItemsInSection(0)
        let lastCellWidth = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: numberOfItems-1, inSection: 0))!.frame.width
        let ignoreWidth = lastCellWidth * (1 - (self.frame.width / contentSize.width))
        let zoom = (self.frame.width - ignoreWidth) / contentSize.width
        self.zoom = zoom
    }
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
