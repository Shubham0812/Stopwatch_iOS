//
//  CAExtensions.swift
//  Stopwatch-Tutorial
//
//  Created by Shubham Singh on 29/05/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit


extension CAShapeLayer {
    func setFillLayerProperties(arcPath: UIBezierPath, trackColor: UIColor, fillColor: UIColor) {
        self.path = arcPath.cgPath
        self.lineWidth = 8
        self.strokeColor =  trackColor.cgColor
        self.lineCap = .round
        self.strokeEnd = 0
        self.fillColor = fillColor.cgColor
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
