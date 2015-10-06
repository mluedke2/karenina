//
//  MockHeartrate.swift
//  Karenina
//
//  Created by Matt Luedke on 10/3/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
  
  static let healthKitStore = HKHealthStore()
  static var timer: NSTimer?
  
  static func authorizeHealthKit() {
    
    let healthKitTypes: Set = [
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
    ]
    
    healthKitStore.requestAuthorizationToShareTypes(healthKitTypes,
      readTypes: healthKitTypes) { _, _ in }
  }
  
  static func saveMockHeartData() {
    
    // 1. Create a heartrate BPM Sample
    let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    let heartRateQuantity = HKQuantity(unit: HKUnit(fromString: "count/min"),
      doubleValue: Double(arc4random_uniform(80) + 100))
    let heartSample = HKQuantitySample(type: heartRateType,
      quantity: heartRateQuantity, startDate: NSDate(), endDate: NSDate())
    
    // 2. Save the sample in the store
    healthKitStore.saveObject(heartSample, withCompletion: { (success, error) -> Void in
      if let error = error {
        print("Error saving heart sample: \(error.localizedDescription)")
      }
    })
  }
  
  static func startMockHeartData() {
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
      target: self,
      selector: "saveMockHeartData",
      userInfo: nil,
      repeats: true)
  }
  
  static func stopMockHeartData() {
    self.timer?.invalidate()
  }
}
