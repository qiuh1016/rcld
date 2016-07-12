//
//  WalkthroughContentViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 12/28/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonTapped() {
        switch index{
        case 0...2:
            let pageViewController = parentViewController as! WalkthroughPageViewController
            pageViewController.forward(index)
        case 3:
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasViewedWalkThrough")
            dismissViewControllerAnimated(true, completion: nil)
        default: break
        }
    }
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        contentLabel.text = content
        imageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index

        switch index{
        case 0...2: nextButton.hidden = true
        case 3: nextButton.hidden = false
        default: break
        }
                
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

}
