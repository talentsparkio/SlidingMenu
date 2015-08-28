//
//  ContentViewController.swift
//  SlidingMenu
//
//  Created by Nick Chen on 8/27/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ContentViewController: UITableViewController {
    weak var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func
        didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        if let delegate = delegate {
            delegate.contentViewControllerDidPressBounceButton(self)
        }
    }

}
