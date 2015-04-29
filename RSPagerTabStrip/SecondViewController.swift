//
//  SecondViewController.swift
//  RSPagerTabStrip
//
//  Created by UGolf_Reese on 15/4/28.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, RSPagerTabStripChildItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Second view did load")

        let label = UILabel()
        label.text = "SecondViewController"
        label.frame = CGRect(x: 30, y: 150, width: 200, height: 28)
        self.view.addSubview(label)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Second view will appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func titleForRSPagerTabStrip(pagerTabStrip: RSPagerTabStripController) -> String {
        return "SecondVC"
    }

}
