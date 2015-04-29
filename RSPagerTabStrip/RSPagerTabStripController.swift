//
//  RSPagerTabStripController.swift
//  RSPagerTabStrip
//
//  Created by UGolf_Reese on 15/4/28.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

@objc protocol RSPagerTabStripChildItem: NSObjectProtocol {
    func titleForRSPagerTabStrip(pagerTabStrip: RSPagerTabStripController) -> String
}

@objc protocol RSPagerTabStripControllerDataSource: NSObjectProtocol {
    func childViewControllerForRSPagerTabStripController(pagerTabStripController: RSPagerTabStripController) -> [UIViewController]
}

class RSPagerTabStripController: UIViewController, UIScrollViewDelegate, RSPagerTabStripControllerDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var currentIndex: Int? = 0
    var lastSelectIndex: Int? = 0
    
    var shouldUpdateTabBarIndicateView: Bool = true
    
    private var containerView: UIScrollView!
    private var buttonBarView: RSButtonBarView!

    var pagerTabStripChildViewControllers: [UIViewController]?
    
    weak var dataSource: RSPagerTabStripControllerDataSource?
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.containerView == nil {
            self.containerView = UIScrollView()
            self.view.addSubview(self.containerView)
        }
        self.containerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64)
        self.containerView.showsHorizontalScrollIndicator = false
        self.containerView.showsVerticalScrollIndicator = false
        self.containerView.bounces = true
        self.containerView.pagingEnabled = true
        self.containerView.delegate = self
        self.containerView.backgroundColor = UIColor.clearColor()
        
        self.dataSource = self
        self.pagerTabStripChildViewControllers = self.childViewControllerForRSPagerTabStripController(self)

        
        if self.buttonBarView == nil {
            self.buttonBarView = RSButtonBarView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
            self.buttonBarView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
            self.view.addSubview(self.buttonBarView)
        }
        self.buttonBarView.delegate = self
        self.buttonBarView.dataSource = self
        self.buttonBarView.registerClass(RSButtonBarViewCell.classForCoder(), forCellWithReuseIdentifier: "CELL")
        self.buttonBarView.leftRightMargin = 8
        self.buttonBarView.labelFont = UIFont(name: "Helvetica-Bold", size: 14.0)!
        self.buttonBarView.labelHightlightColor = UIColor.blueColor()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateContent()
        self.buttonBarView.selectItemAtIndexPath(NSIndexPath(forRow: self.currentIndex!, inSection: 0), animated: false, scrollPosition: .None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Private Methods
    
    func updateContent() ->Void {
        
        let itemsCount = CGFloat(self.pagerTabStripChildViewControllers!.count)
        self.containerView.contentSize = CGSize(width: self.containerView.frame.width * itemsCount, height: self.containerView.frame.height)
        
        for i in 0..<self.pagerTabStripChildViewControllers!.count {
            let childController = self.pagerTabStripChildViewControllers![i]
            let pageOffsetForChild = self.pageOffsetForIndex(i)
            if fabs(self.containerView.contentOffset.x - pageOffsetForChild) < CGRectGetWidth(self.containerView.frame) {
                if let parentController = childController.parentViewController {
                    childController.didMoveToParentViewController(self)
                    childController.view.frame = CGRect(x: pageOffsetForChild, y: 0, width: CGRectGetWidth(self.containerView.frame), height: CGRectGetHeight(self.containerView.frame))
                    childController.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                }
                else {
                    self.addChildViewController(childController)
                    childController.didMoveToParentViewController(self)
                    childController.view.frame = CGRect(x: pageOffsetForChild, y: 0, width: CGRectGetWidth(self.containerView.frame), height: CGRectGetHeight(self.containerView.frame))
                    childController.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                    self.containerView.addSubview(childController.view)
                }
            }
            else {
                if let parentController = childController.parentViewController {
                    childController.view.removeFromSuperview()
                    childController.willMoveToParentViewController(nil)
                    childController.removeFromParentViewController()
                }
            }
        }
        
        
        let containerWidth = self.containerView.frame.width

        if self.containerView.decelerating && !self.buttonBarView.isSkipViewControllers {
            if self.containerView.contentOffset.x > containerWidth * CGFloat(self.currentIndex!) + containerWidth / 2 {
                ++self.currentIndex!
                self.buttonBarView.selectItemAtIndexPath(NSIndexPath(forRow: self.currentIndex!, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            }
            else if self.containerView.contentOffset.x < containerWidth * CGFloat(self.currentIndex!) - containerWidth / 2 {
                --self.currentIndex!
                self.buttonBarView.selectItemAtIndexPath(NSIndexPath(forRow: self.currentIndex!, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            }
        }

        if self.shouldUpdateTabBarIndicateView {
            let progressPercentage = (self.containerView.contentOffset.x - CGFloat(self.lastSelectIndex!) * containerWidth) / containerWidth
            var toIndex = self.lastSelectIndex!
            if self.containerView.contentOffset.x > (CGFloat(self.lastSelectIndex!) * containerWidth) {
                toIndex = min(self.lastSelectIndex! + 1, self.pagerTabStripChildViewControllers!.count - 1)
                
            }else if self.containerView.contentOffset.x < (CGFloat(self.lastSelectIndex!) * containerWidth) {
                toIndex = max((self.lastSelectIndex! - 1), 0)
            }
            self.buttonBarView.moveToIndex(toIndex, fromIndex: self.lastSelectIndex!, withProgressPercentage: progressPercentage)
        }else {
//            var progressPercentage = (self.containerView.contentOffset.x - CGFloat(self.lastSelectIndex!) * containerWidth) / (CGFloat(self.currentIndex! - self.lastSelectIndex!) * containerWidth)
//            progressPercentage *= self.currentIndex! > self.lastSelectIndex! ? 1 : -1
//            self.buttonBarView.moveToIndex(self.currentIndex!, fromIndex: self.lastSelectIndex!, withProgressPercentage: progressPercentage)
        }
    }
  
    
    // MARK: - ScrollView delegate

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == self.containerView {
            self.shouldUpdateTabBarIndicateView = true
            self.lastSelectIndex = self.currentIndex!
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.containerView {
            self.updateContent()
        }
    }
    
    
    // MARK: - RSPagerTabStripController DataSource
    
    func childViewControllerForRSPagerTabStripController(pagerTabStripController: RSPagerTabStripController) -> [UIViewController] {
        return self.pagerTabStripChildViewControllers ?? []
    }
    
    
    // MARK: - CollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! RSButtonBarViewCell
        let childViewController = self.pagerTabStripChildViewControllers![indexPath.row]
        if childViewController.conformsToProtocol(RSPagerTabStripChildItem) {
            cell.label.text = (childViewController as! RSPagerTabStripChildItem).titleForRSPagerTabStrip(self)
        }else {
            cell.label.text = "Not Define"
        }
        cell.label.font = self.buttonBarView.labelFont
        cell.hightlightColor = self.buttonBarView.labelHightlightColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pagerTabStripChildViewControllers?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let label = UILabel()
        let childViewController = self.pagerTabStripChildViewControllers![indexPath.row]
        if childViewController.conformsToProtocol(RSPagerTabStripChildItem) {
            label.text = (childViewController as! RSPagerTabStripChildItem).titleForRSPagerTabStrip(self)
        }else {
            label.text = "Not Define"
        }
        label.font = self.buttonBarView.labelFont
        label.sizeToFit()
        return CGSize(width: label.frame.width + (self.buttonBarView.leftRightMargin * 2), height: self.buttonBarView.frame.height)
    }
    
    // MARK: - CollectionView Delegate 
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        self.shouldUpdateTabBarIndicateView = false
        self.buttonBarView.isSkipViewControllers = true
        self.lastSelectIndex = self.currentIndex!
        self.currentIndex = indexPath.row
        self.containerView.setContentOffset(CGPoint(x: (self.containerView.frame.width * CGFloat(self.currentIndex!)), y: 0), animated: true)
        self.buttonBarView.moveToIndex(self.currentIndex!, fromIndex: self.lastSelectIndex!)
    }
    
    // MARK: - Helpers
    
    private func pageOffsetForIndex(index: Int) -> CGFloat {
        return (CGFloat(index) * CGRectGetWidth(self.containerView.frame))
    }
    
    
    
    
    
    
    
    
    
}
