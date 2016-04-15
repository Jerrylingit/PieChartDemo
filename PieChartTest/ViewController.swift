//
//  ViewController.swift
//  PieChartTest
//
//  Created by admin on 16/4/8.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pieView: PieChartView!
    @IBOutlet weak var rotationBtn: UIButton!
    
    var i:Int = 1
    var containerLayer:CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        let frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 100)
        let pieView = PieChartView(frame: frame, dataItem: [10,20,30,40,50,60,70])
        pieView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        self.pieView = pieView
        self.view.addSubview(pieView)
    }
    
    @IBAction func rotateAction(sender: AnyObject) {
        
        pieView.reDraw(i)
        i += 1
        if i == 7{
            i = 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

