//
//  SlideOutAnimationController.swift
//  renchuanliandong
//
//  Created by qiuh1016 on 12/14/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey), let containerView = transitionContext.containerView() {
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: {
                fromView.center.y -= containerView.bounds.size.height
                fromView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                }, completion: {finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
