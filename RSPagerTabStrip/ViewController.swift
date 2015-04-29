//
//  ViewController.swift
//  RSPagerTabStrip
//
//  Created by UGolf_Reese on 15/4/28.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

class ViewController: RSPagerTabStripController {

    let titles = ["最新", "快报", "视频", "新闻", "评测", "导购", "行情", "用车", "技术", "文化", "改装", "游记", "原创视频", "说客"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    override func childViewControllerForRSPagerTabStripController(pagerTabStripController: RSPagerTabStripController) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        for i in 0..<titles.count {
            let vc = BaseViewController()
            vc.pagerTabStripTitle = titles[i]
            let label = UILabel()
            label.text = titles[i]
            label.frame = CGRect(x: 140, y: 180, width: 0, height: 0)
            label.sizeToFit()
            vc.view.addSubview(label)
            viewControllers.append(vc)
        }
        return viewControllers
    }



}

