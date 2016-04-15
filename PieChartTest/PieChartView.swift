//
//  PieChartView.swift
//  PieChartTest
//
//  Created by admin on 16/4/11.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    var rectLayer:CAShapeLayer!
    var angle:CGFloat = CGFloat(M_PI_2)
    
    //MARK: - properties (public)
    var lineWidth:CGFloat = 10
    
    
    //MARK: - properties (private)
    private var itemTitleLabel:UILabel!
    private var itemMoneyLabel:UILabel!
    private var itemIconBtn:UIButton!
    private var itemPercentage:UILabel!
    private var itemAccountCount:UILabel!
    private var rotateBtn:UIButton!
    
    private var dataItem:Array<CGFloat>
    private var itemValueAmount:CGFloat{
        var amount:CGFloat = 0
        for value in dataItem{
            amount += value
        }
        return amount
    }
    private var containerLayer:CAShapeLayer!
    
    

    
    //MARK: - init
    init(frame:CGRect, dataItem:Array<CGFloat>){
        self.dataItem = dataItem
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - operations (internal)
    func reDraw(index:Int){
        var curIndex = index - 1
        if index == 0{
            curIndex = dataItem.count - 1
        }
        
        var rotateRadian = dataItem[curIndex] / itemValueAmount + dataItem[index] / itemValueAmount
        rotateRadian = -rotateRadian * CGFloat(M_PI)
        rotateContainerLayerWithRadian(rotateRadian)
    }
    
    //MARK: - setupViews (private)
    private func setupViews(){
        setupRotateLayers()
    }
    
    private  func setupRotateLayers(){
        
        let radius = self.frame.width / 4
        let layerWidth = self.frame.width / 2
        
        containerLayer = CAShapeLayer()
        containerLayer.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.width)
        var percentageStart:CGFloat = 0
        var percentageEnd:CGFloat = 0
        for i in 0...dataItem.count - 1{
            percentageEnd += dataItem[i] / itemValueAmount
            let pieLayer = generateLayers(radius, layerFrameWidth: layerWidth, percentageStart: percentageStart, percentageEnd: percentageEnd)
            containerLayer.addSublayer(pieLayer)
            percentageStart = percentageEnd
        }
        gradientMask(radius, width: layerWidth)
        let initRotateRadian = -CGFloat(M_PI) * dataItem[0] / itemValueAmount
        rotateContainerLayerWithRadian(initRotateRadian)
        self.layer.addSublayer(containerLayer)
    }
    
    private func gradientMask(radius:CGFloat, width:CGFloat){
        containerLayer.mask = generateLayers(radius, layerFrameWidth: width, percentageStart: 0, percentageEnd: 1)
        let gradientAnimation = CABasicAnimation(keyPath: "strokeEnd")
        gradientAnimation.fromValue = 0
        gradientAnimation.toValue = 1
        gradientAnimation.duration = 0.7
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        containerLayer.mask?.addAnimation(gradientAnimation, forKey: "gradientAnimation")
    }
    
    private func generateLayers(radius:CGFloat, layerFrameWidth:CGFloat, percentageStart:CGFloat, percentageEnd:CGFloat) -> CAShapeLayer{
        
        let path = UIBezierPath(arcCenter: CGPointMake(radius, radius), radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(3 * M_PI_2) , clockwise: true)
        let pieLayer = CAShapeLayer()
        pieLayer.path = path.CGPath
        pieLayer.frame = CGRectMake(0, 0, layerFrameWidth, layerFrameWidth)
        pieLayer.position = CGPointMake(self.frame.width / 2, self.frame.width / 2)
        pieLayer.lineWidth = lineWidth
        pieLayer.strokeColor = UIColor(hue: percentageEnd, saturation: 0.5, brightness: 0.75, alpha: 1.0).CGColor
        pieLayer.fillColor = nil
        pieLayer.strokeStart = percentageStart
        pieLayer.strokeEnd = percentageEnd
        return pieLayer
    }
    
    private func rotateContainerLayerWithRadian(radian:CGFloat){
        
        let myAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let myRotationTransform = CATransform3DRotate(containerLayer.transform, radian, 0, 0, 1)
        if let rotationAtStart = containerLayer.valueForKeyPath("transform.rotation") {
            
            myAnimation.fromValue = rotationAtStart.floatValue
            myAnimation.toValue = CGFloat(rotationAtStart.floatValue) + radian
        }
        containerLayer.transform = myRotationTransform
        myAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        containerLayer.addAnimation(myAnimation, forKey: "transform.rotation")
    }
    
}
