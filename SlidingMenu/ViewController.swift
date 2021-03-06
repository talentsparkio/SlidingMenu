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
    
    var isMenuOpen = false

    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let pushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
    var panAttachmentBehavior: UIAttachmentBehavior!
    
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
        
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOpacity = 1.0;
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).CGPath
        contentView.layer.shadowOffset = CGSizeZero;
        contentView.layer.shadowRadius = 5.0;
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
        pushBehavior.magnitude = 0.0
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (gestureRecognizer === leftScreenEdgeGestureRecognizer && isMenuOpen == false) {
            return true
        } else if (gestureRecognizer === rightScreenEdgeGestureRecognizer && isMenuOpen == true) {
            return true
        }
        
        return false
    }
    
    func handleScreenEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
        var location = recognizer.locationInView(view)
        location.y = CGRectGetMidY(contentView.bounds)
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            animator.removeBehavior(gravityBehavior)
            panAttachmentBehavior = UIAttachmentBehavior(item: contentView, attachedToAnchor:location)
            animator.addBehavior(panAttachmentBehavior)
        } else if (recognizer.state == UIGestureRecognizerState.Changed) {
            panAttachmentBehavior.anchorPoint = location
        } else if (recognizer.state == UIGestureRecognizerState.Ended) {
            animator.removeBehavior(panAttachmentBehavior)
            
            let velocity = recognizer.velocityInView(view)
            
            if(velocity.x > 0) { // opening the menu
                isMenuOpen = true
                gravityBehavior.gravityDirection = CGVectorMake(1,0)
            } else { // closing the menu
                isMenuOpen = false
                gravityBehavior.gravityDirection = CGVectorMake(-1,0)
            }
            
            animator.addBehavior(gravityBehavior)
            
            pushBehavior.pushDirection = CGVectorMake(velocity.x / 10.0, 0.0)
            pushBehavior.active = true
        }
        
    }
}

