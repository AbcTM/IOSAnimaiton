//
//  ViewController.swift
//  CAReplicatorLayer
//
//  Created by tm on 2018/12/1.
//  Copyright © 2018 tm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupLayer()
//        animation()
        pathAnimation()
    }
    
    
    func pathAnimation() {
        
        
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer.position = view.center
        layer.cornerRadius = 15
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 6
        view.layer.addSublayer(layer)
        
        
        let path = UIBezierPath.init(roundedRect: layer.bounds, cornerRadius: 15)
        
        let animation1 = CABasicAnimation.init(keyPath: "strokeEnd")
        animation1.fromValue = 0
        animation1.toValue = 1
        animation1.duration = 5
        
        layer.path = path.cgPath
        layer.add(animation1, forKey: "strokeAnimation")
    }
    
    func animation() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        layer.position = CGPoint(x: 20, y: 20)
        layer.backgroundColor = UIColor.red.cgColor
        layer.cornerRadius = 15
        view.layer.addSublayer(layer)
        
        let animation = CABasicAnimation.init(keyPath: "transform")
        animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(5, 5, 1))
        
        let animation1 = CABasicAnimation.init(keyPath: "opacity")
        animation1.fromValue = 1
        animation1.toValue = 0
        animation1.duration = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, animation1]
        animationGroup.duration = 2
        animationGroup.repeatCount = HUGE
        
        layer.add(animationGroup, forKey: "gr")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.addSublayer(layer)
        
        view.layer.addSublayer(replicatorLayer)
    }
    
    func setupLayer() {
        //创建
        let replicator = CAReplicatorLayer()
        replicator.frame = view.frame
        
        //设置复制图层个数
        replicator.instanceCount = 30
        //复制间隔
        replicator.instanceDelay = CFTimeInterval(1/30.0)
        //一般为false
        replicator.preservesDepth = false
        //图层颜色
        replicator.instanceColor = UIColor.white.cgColor
        
        //偏移量
        replicator.instanceRedOffset = 0
        replicator.instanceGreenOffset = -1
        replicator.instanceBlueOffset = -1
        replicator.instanceAlphaOffset = 0
        
        //角度
        let angle = CGFloat(CGFloat.pi*2.0)/30
        replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        //子图层
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 10
        let X = view.bounds.midX - layerWidth/2
        let Y = view.bounds.midY - 100;
        instanceLayer.frame = CGRect(x: X, y: Y, width: layerWidth, height: layerWidth*3)
        instanceLayer.backgroundColor = UIColor.red.cgColor
        replicator.addSublayer(instanceLayer)
        
        //设置动画
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float(Int.max)
        
        //设置初始时为透明，并且添加动画
        instanceLayer.opacity = 0
        instanceLayer.add(fadeAnimation, forKey: "FadAnimation")
        view.layer.addSublayer(replicator)
    }
    
    func loadAnimation1() {
        //
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        layer.position = CGPoint(x: 20, y: 20)
        layer.backgroundColor = UIColor.red.cgColor
        layer.cornerRadius = 15
        view.layer.addSublayer(layer)
        
        // 透明度动画
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.autoreverses = true
        
        let animation1 = CABasicAnimation.init(keyPath: "transform.scale")
        animation1.fromValue = 0.5
        animation1.toValue = 1.5
        animation1.duration = 1.5
        animation1.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, animation1]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.autoreverses = true
        
        layer.add(animationGroup, forKey: "ani")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(50, 0, 0)
        replicatorLayer.addSublayer(layer)
        
        view.layer.addSublayer(replicatorLayer)
        
        let replicatorLayer1 = CAReplicatorLayer()
        replicatorLayer1.instanceCount = 3
        replicatorLayer1.instanceDelay = 0.5
        replicatorLayer1.instanceTransform = CATransform3DMakeTranslation(0, 50, 0)
        replicatorLayer1.addSublayer(replicatorLayer)
        
        view.layer.addSublayer(replicatorLayer1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

