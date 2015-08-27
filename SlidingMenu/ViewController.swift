//
//  ViewController.swift
//  SlidingMenu
//
//  Created by Nick Chen on 8/26/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var contentView: UIView!
    var animator: UIDynamicAnimator!
    
    // You need to set up screen edge gesture recognizers programmatically
    // There is a bug in interface builder
    // http://stackoverflow.com/questions/26256985/how-do-i-set-up-an-uiscreenedgepangesturerecognizer-using-interface-builderhttp://stackoverflow.com/questions/26256985/how-do-i-set-up-an-uiscreenedgepangesturerecognizer-using-interface-builder
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleScreenEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
    }
}

