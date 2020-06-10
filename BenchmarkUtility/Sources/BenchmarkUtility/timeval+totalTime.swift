//
//  timeval+totalTime.swift
//  BenchmarkUtility
//
//  Created by Ethan Kusters on 6/9/20.
//

import Foundation

extension timeval {
    var totalTime: Double {
        Double(tv_sec) + ((1.0 / 1000000.0) * Double(tv_usec))
    }
}
