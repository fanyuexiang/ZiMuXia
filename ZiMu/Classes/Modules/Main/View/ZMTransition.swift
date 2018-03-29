//
//  ZMTransition.swift
//  ZiMu
//
//  Created by fancy on 2018/3/28.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation

class PushTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        toVC?.view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        
        let containerVC = transitionContext.containerView
        
        containerVC.insertSubview(toVC!.view, aboveSubview: fromVC!.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            toVC?.view.frame = CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64)
            
        }, completion: { (isFinish) in
            transitionContext.completeTransition(isFinish)
            toVC!.view.layoutIfNeeded()
        })
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.transitionContext?.completeTransition(transitionContext!.transitionWasCancelled)
        
    }
}

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containerVC = transitionContext.containerView
        
        containerVC.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            fromVC?.view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight - 64)
            
        }, completion: { (isFinish) in
            transitionContext.completeTransition(isFinish)
            toVC!.view.layoutIfNeeded()
        })
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.transitionContext?.completeTransition(transitionContext!.transitionWasCancelled)
        
    }
    
    
}
