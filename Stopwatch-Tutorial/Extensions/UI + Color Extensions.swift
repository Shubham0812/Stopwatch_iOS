//
//  UI + Color Extensions.swift
//  Stopwatch-Tutorial
//
//  Created by Shubham Singh on 29/05/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit


extension Int{
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}
