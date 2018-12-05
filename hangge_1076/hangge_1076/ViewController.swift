//
//  ViewController.swift
//  hangge_1076
//
//  Created by hangge on 2017/2/21.
//  Copyright © 2017年 hangge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var oProgressView1: OProgressView!
    @IBOutlet weak var oProgressView2: OProgressView2!
    @IBOutlet weak var oProgressView3: OProgressView3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //增加进度
    @IBAction func addProgress(_ sender: AnyObject) {
        oProgressView1.setProgress(oProgressView1.progress + 25, animated: true)
        oProgressView2.setProgress(oProgressView2.progress + 25, animated: true)
        oProgressView3.setProgress(oProgressView3.progress + 25, animated: true)
    }
    
    //减少进度
    @IBAction func minusProgress(_ sender: AnyObject) {
        oProgressView1.setProgress(oProgressView1.progress - 20, animated: true)
        oProgressView2.setProgress(oProgressView2.progress - 20, animated: true)
        oProgressView3.setProgress(oProgressView3.progress - 20, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

