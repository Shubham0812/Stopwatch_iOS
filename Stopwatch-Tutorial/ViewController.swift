//
//  ViewController.swift
//  Stopwatch-Tutorial
//
//  Created by Shubham Singh on 29/05/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stopwatchContainerView: UIView!
    @IBOutlet weak var stopwatchTimeLabel: UILabel!
    @IBOutlet weak var stopwatchSecondsLabel: UILabel!
    @IBOutlet weak var stopwatchControlButton: UIButton!
    
    let stopwatchTrackLayer = CAShapeLayer()
    let stopwatchCircleFillLayer = CAShapeLayer()
    let stopwatchRoundLayer = CAShapeLayer()
    
    var stopwatchTimer = Timer()
    var stopwatchSecondTimer = Timer()
    var stopwatchAnimationTimer = Timer()
    
    var trackColor = UIColor.gray.withAlphaComponent(0.5)
    var trackFillColor = UIColor.systemRed
    var trackLeadColor = UIColor.systemOrange
    
    var initialValue: CGFloat = 0.7
    
    var stopwatchSecondCount = 0
    var stopwatchMinuteCount = 0
    var milliSeconds = 0
    
    var stopwatchStarted = false
    
    lazy var strokeStartAnimation: CABasicAnimation = {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.duration = 60
        strokeStart.toValue = 1
        strokeStart.fillMode = .forwards
        return strokeStart
    }()
    
    lazy var strokeEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.duration = 60
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        return strokeEnd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopwatchContainerView.backgroundColor = UIColor.systemBackground
        
        // get the dimensions of the containerView and create a circle with a radius of 140
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: stopwatchContainerView.frame.origin.x + (stopwatchContainerView.frame.width / 2) - 24, y: stopwatchContainerView.frame.origin.y - (stopwatchContainerView.frame.height / 2)), radius: 140, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // set the stopwatchTrackLayer
        stopwatchTrackLayer.path = arcPath.cgPath
        stopwatchTrackLayer.strokeColor = trackColor.cgColor
        stopwatchTrackLayer.lineWidth = 8
        stopwatchTrackLayer.lineCap = .round
        stopwatchTrackLayer.fillColor = UIColor.clear.cgColor
        
        // set the stopwatchCircleFillLayer
        stopwatchCircleFillLayer.path = arcPath.cgPath
        stopwatchCircleFillLayer.lineWidth = 8
        stopwatchCircleFillLayer.strokeColor =  trackFillColor.cgColor
        stopwatchCircleFillLayer.lineCap = .round
        stopwatchCircleFillLayer.strokeEnd = 0
        stopwatchCircleFillLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        
        // set the stopwatchRoundLayer
        stopwatchRoundLayer.path = arcPath.cgPath
        stopwatchRoundLayer.lineWidth = 12
        stopwatchRoundLayer.strokeColor = trackLeadColor.cgColor
        stopwatchRoundLayer.fillColor = UIColor.clear.cgColor
        stopwatchRoundLayer.strokeStart = (self.initialValue) / 100
        stopwatchRoundLayer.strokeEnd = (self.initialValue) / 100 + 0.004
        stopwatchRoundLayer.lineCap = .round
        
        // add the layers to the containerView
        stopwatchContainerView.layer.addSublayer(stopwatchTrackLayer)
        stopwatchContainerView.layer.addSublayer(stopwatchCircleFillLayer)
        stopwatchContainerView.layer.addSublayer(stopwatchRoundLayer)
        
        // customize the controlButton
        stopwatchControlButton.layer.cornerRadius = 24
        stopwatchControlButton.backgroundColor = UIColor.systemIndigo
        stopwatchControlButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    //MARK:- Outlets for the viewController
    @IBAction func stopwatchControlPressed(_ sender: Any) {
        // stop all the timers on click of the control button
        self.stopwatchTimer.invalidate()
        self.stopwatchSecondTimer.invalidate()
        self.stopwatchAnimationTimer.invalidate()
        
        if (!stopwatchStarted) {
            // set the controlButton
            self.stopwatchControlButton.setTitle("Stop", for: .normal)
            self.stopwatchControlButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
            
            // starts the stopwatch
            self.startStopwatch()
        } else {
            // sets the controlButton
            self.stopwatchControlButton.setTitle("Start", for: .normal)
            self.stopwatchControlButton.backgroundColor = UIColor.systemIndigo
            
            // stops the stopwatch
            self.resetStopwatch()
        }
        self.stopwatchStarted = !self.stopwatchStarted
    }
    
    //MARK:- functions for the viewController
    func startStopwatch(){
        // start the milliSeconds Timer
        stopwatchSecondTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.milliSeconds += 1
            self.stopwatchSecondsLabel.text = ".\(self.milliSeconds)"
        })
        
        // start the minute & seconds timer
        stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.milliSeconds = 0
            self.stopwatchSecondsLabel.text = ".00"
            self.stopwatchSecondCount += 1
            
            if (self.stopwatchSecondCount == 60){
                self.stopwatchSecondCount = 0
                self.stopwatchMinuteCount += 1
            }
            self.stopwatchTimeLabel.text = "\(Int(self.stopwatchMinuteCount).appendZeros()):\(Int(self.stopwatchSecondCount).appendZeros())"
        }
        // start the animation for the Layers for the first time
        animateStopwatch()
        
        // repeat filling of the circle layers every 60 seconds.
        stopwatchAnimationTimer =  Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { (Timer) in
            // swap the colors to give a nice effect on the trackLayer
            let tempColor = self.trackLeadColor
            self.trackLeadColor = self.trackFillColor
            self.trackFillColor = tempColor
            
            self.stopwatchTrackLayer.strokeColor = self.trackLeadColor.withAlphaComponent(0.25).cgColor
            self.animateStopwatch()
        }
    }
    
    // function to animates the layers
    func animateStopwatch(){
        self.stopwatchCircleFillLayer.add(self.strokeEndAnimation, forKey: "circleShape")
        self.stopwatchRoundLayer.add(self.strokeStartAnimation, forKey: "roundShape")
        self.stopwatchRoundLayer.add(self.strokeEndAnimation, forKey: "roundEnd")
    }
    
    // function to reset the stopWatch
    func resetStopwatch(){
        // set all the values to default
        self.stopwatchSecondCount = 0
        self.initialValue = 0.7
        self.milliSeconds = 0
        self.stopwatchMinuteCount = 0
        
        // reset the layers to the starting point
        self.stopwatchRoundLayer.strokeStart = (self.initialValue) / 100
        self.stopwatchRoundLayer.strokeEnd = (self.initialValue) / 100 + 0.004
        self.stopwatchCircleFillLayer.strokeEnd = 0
        self.stopwatchTimeLabel.text = "00:00"
        self.stopwatchSecondsLabel.text = ".00"
        
        // reset the colors of the layers
        trackFillColor = UIColor.systemRed
        trackLeadColor = UIColor.systemOrange
        trackColor = UIColor.gray.withAlphaComponent(0.5)
        
        // remove all the animations from the layers
        self.stopwatchCircleFillLayer.removeAllAnimations()
        self.stopwatchRoundLayer.removeAllAnimations()
    }
}
