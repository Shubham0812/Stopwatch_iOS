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
    @IBOutlet weak var stopwatchpauseButton: UIButton!
    
    
    
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
    var microSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopwatchContainerView.backgroundColor = UIColor.systemBackground
        
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: stopwatchContainerView.frame.origin.x + (stopwatchContainerView.frame.width / 2) - 24, y: stopwatchContainerView.frame.origin.y - (stopwatchContainerView.frame.height / 2)), radius: 140, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        stopwatchTrackLayer.setTrackLayer(arcPath: arcPath, trackColor: trackColor)
        stopwatchCircleFillLayer.setFillLayerProperties(arcPath: arcPath, trackColor: trackFillColor)
        stopwatchRoundLayer.setRoundFillerLayer(arcPath: arcPath, trackColor: trackLeadColor, strokeStart: (self.initialValue) / 100, strokeEnd: (self.initialValue) / 100 + 0.004)

        
        stopwatchContainerView.layer.addSublayer(stopwatchTrackLayer)
        stopwatchContainerView.layer.addSublayer(stopwatchCircleFillLayer)
        stopwatchContainerView.layer.addSublayer(stopwatchRoundLayer)
        
        
        stopwatchControlButton.layer.cornerRadius = 24
        stopwatchControlButton.backgroundColor = UIColor.systemIndigo
        stopwatchControlButton.setTitleColor(UIColor.white, for: .normal)
        
        stopwatchpauseButton.layer.opacity = 0.6
        stopwatchpauseButton.isHidden = true
        
        
        stopwatchSecondTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.microSeconds += 1
            self.stopwatchSecondsLabel.text = ".\(self.microSeconds)"
        })
        
        stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.microSeconds = 0
            self.stopwatchSecondsLabel.text = ".00"
            self.stopwatchSecondCount += 1
            if (self.stopwatchSecondCount == 60) {
                self.stopwatchTimeLabel.text = "\(Int(self.stopwatchMinuteCount + 1).appendZeros()):\(0.appendZeros())"
            } else {
                self.stopwatchTimeLabel.text = "\(Int(self.stopwatchMinuteCount).appendZeros()):\(Int(self.stopwatchSecondCount).appendZeros())"
            }
        }
        
        stopwatchAnimationTimer =  Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { (Timer) in
            UIColor.swapColor(color1: &self.trackFillColor, color2: &self.trackLeadColor)
            self.stopwatchTrackLayer.strokeColor = self.trackLeadColor.withAlphaComponent(0.25).cgColor
            self.stopwatchSecondCount = 0
            self.stopwatchMinuteCount += 1
            self.animateStopwatch()
        }
        
        
        animateStopwatch()
    }
    
    
    //MARK:- Outlets for the viewController
    @IBAction func stopwatchControlPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func stopwatchPaused(_ sender: Any) {
    }
    
    
    //MARK:- functions for the viewController
    
    
    
    func animateStopwatch(){
        self.stopwatchCircleFillLayer.add(self.strokeEndAnimation, forKey: "circleShape")
        self.stopwatchRoundLayer.add(self.strokeStartAnimation, forKey: "roundShape")
        self.stopwatchRoundLayer.add(self.strokeEndAnimation, forKey: "roundEnd")
    }
}

extension CAShapeLayer {
    func setFillLayerProperties(arcPath: UIBezierPath, trackColor: UIColor) {
        self.path = arcPath.cgPath
        self.lineWidth = 8
        self.strokeColor =  trackColor.cgColor
        self.lineCap = .round
        self.strokeEnd = 0
        self.fillColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    func setTrackLayer(arcPath: UIBezierPath, trackColor: UIColor){
        self.path = arcPath.cgPath
        self.strokeColor = trackColor.cgColor
        self.lineWidth = 8
        self.lineCap = .round
        self.fillColor = UIColor.clear.cgColor
    }
    
    func setRoundFillerLayer(arcPath: UIBezierPath, trackColor: UIColor, strokeStart: CGFloat, strokeEnd: CGFloat){
        self.path = arcPath.cgPath
        self.lineWidth = 12
        self.strokeColor = trackColor.cgColor
        self.fillColor = UIColor.clear.cgColor
        self.strokeStart = strokeStart
        self.strokeEnd = strokeEnd
        self.lineCap = .round
    }
}

extension Int{
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func degreeToRadians() -> CGFloat {
       return  (CGFloat(self) * .pi) / 180
    }
}


extension UIColor{
    static func swapColor(color1: inout UIColor, color2: inout UIColor) {
        let temp = color1
        color1 = color2
        color2 = temp
    }
}
