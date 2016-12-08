//
//  Delay.swift
//  PonApp
//
//  Created by HaoLe on 12/8/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import Foundation

/// Delay execution by some DispatchTimeInterval. Runs on the main thread.
///
/// - Parameter by: The DispatchTimeInterval to delay execution by
/// - Parameter closure: The closure to run.
func delay(by delay: DispatchTimeInterval, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
}
