//
//  ViewController.swift
//  SlidingMenu
//
//  Created by Nick Chen on 8/26/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate, UIGestureRecognizerDelegate {
    let RIGHT_EDGE_INSET = CGFloat(50.0)
    
    @IBOutlet weak var contentView: UIView!
    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let pushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
    
    // You need to set up screen edge gesture recognizers programmatically
    // There is a bug in interface builder
    // http://stackoverflow.com/questions/26256985/how-do-i-set-up-an-uiscreenedgepangesturerecognizer-using-interface-builder
    var leftScreenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var rightScreenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target:self, action:"handleScreenEdgePan:")
        self.leftScreenEdgeGestureRecognizer.edges = UIRectEdge.Left
        self.leftScreenEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.leftScreenEdgeGestureRecognizer)
        
        self.rightScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target:self, action:"handleScreenEdgePan:")
        self.rightScreenEdgeGestureRecognizer.edges = UIRectEdge.Right
        self.rightScreenEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.rightScreenEdgeGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAnimation()
    }
    
    func setupAnimation() {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Collision behavior for the right edge
        // We need some gap or else it will not provide affordances to slide back
        let collisionBehavior = UICollisionBehavior(items: [contentView])
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(0, 0, 0, RIGHT_EDGE_INSET - UIScreen.mainScreen().bounds.size.width))
        animator.addBehavior(collisionBehavior)
        
        // Gravity is going to pull horizontally instead of vertically
        gravityBehavior.addItem(contentView)
        gravityBehavior.gravityDirection = CGVectorMake(-1, 0)
        animator.addBehavior(gravityBehavior)
        
        // Add a slight push to help move things along - no push initially
        pushBehavior.addItem(contentView)
        pushBehavior.angle = 0.0
        pushBehavior.angle = 0.0
        animator.addBehavior(pushBehavior)
        
        // Give the content view some bounce
        let itemBehavior = UIDynamicItemBehavior(items: [contentView])
        itemBehavior.elasticity = 0.45
        animator.addBehavior(itemBehavior)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "contentViewController" {
            let contentViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ContentViewController
            contentViewController.delegate = self;
        }
    }
    
    func contentViewControllerDidPressBounceButton(controller: ContentViewController) {
        pushBehavior.pushDirection = CGVectorMake(35.0, 0.0)
        pushBehavior.active = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleScreenEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
    }
}

