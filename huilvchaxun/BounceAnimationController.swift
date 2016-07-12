//
//  BounceAnimationController.swift
//  renchuanliandong
//
//  Created by qiuh1016 on 12/14/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let toView = transitionContext.viewForKey(UITransitionContextToViewKey), let containerView = transitionContext.containerView() {
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            containerView.addSubview(toView)
            toView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0, options: .CalculationModeCubic, animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.334, animations: {
                    toView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                })
                UIView.addKeyframeWithRelativeStartTime(0.334, relativeDuration: 0.333, animations: {
                    toView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                })
                UIView.addKeyframeWithRelativeStartTime(0.666, relativeDuration: 0.333, animations: {
                    toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                })
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
}
