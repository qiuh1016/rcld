//
//  WalkthroughPageViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 12/28/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["本船信息界面", "打卡记录界面", "港口信息界面", "轨迹显示界面"]
    var pageImages = ["myshipView", "dakaView", "fenceView", "routeView"]
    var pageContents = ["显示本船详细信息，提供防盗及开灯寻船功能，可查看船员信息及打卡信息，并支持信息修改", "显示船员打卡信息：打卡人员、打卡时间、身份证信息等", "显示附近港口列表并提供泊位信息，供您选择合适的港口进行停靠", "根据起始时间显示船只轨迹，1000个点以内还可以显示每个轨迹点的位置"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let startingViewController = viewControllerAtIndex(0){
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return viewControllerAtIndex(index)
    }

    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController?{
        if index == NSNotFound || index < 0 || index >= pageHeadings.count{
            return nil
        }
        let sb = UIStoryboard(name: "Walkthrough", bundle: NSBundle.mainBundle()) //
        if let pageContentViewController = sb.instantiateViewControllerWithIdentifier("WalkthroughContentController") as? WalkthroughContentViewController {
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.content = pageContents[index]
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    func forward(index: Int){
        if let nextViewController = viewControllerAtIndex(index + 1){
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
}












