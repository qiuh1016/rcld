//
//  AlphaViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 12/21/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class AlphaPresentationController: UIPresentationController {
    
    lazy var alphaView: UIView = {
        let alphaView = UIView()
        alphaView.frame = CGRect.zero
        alphaView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return alphaView
    }()
    
    override func presentationTransitionWillBegin() {
        alphaView.frame = containerView!.bounds
        containerView!.insertSubview(alphaView, atIndex: 0)
        
        alphaView.alpha = 0
        if let transitionCoordinator = presentedViewController.transitionCoordinator(){
            transitionCoordinator.animateAlongsideTransition({_ in
                self.alphaView.alpha = 1
                }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator(){
            transitionCoordinator.animateAlongsideTransition({_ in
                self.alphaView.alpha = 0
                }, completion: nil)
        }
    }
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}
