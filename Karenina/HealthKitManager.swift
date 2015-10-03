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
  
  static func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
  {
    // 1. Set the types you want to read from HK Store
    let healthKitTypesToRead: Set = [
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
    ]
    
    // 2. Set the types you want to write to HK Store
    let healthKitTypesToWrite: Set = [
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
    ]
    
    // 3. If the store is not available (for instance, iPad) return an error and don't go on.
    if !HKHealthStore.isHealthDataAvailable()
    {
      let error = NSError(domain: "com.raywenderlich.Karenina", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
      if( completion != nil )
      {
        completion(success:false, error:error)
      }
      return;
    }
    
    // 4.  Request HealthKit authorization
    healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success, error) -> Void in
      
      if( completion != nil )
      {
        completion(success:success,error:error)
      }
    }
  }
  
  static func saveMockHeartData() {
    
    // 1. Create a heartrate BPM Sample
    let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    let heartRateQuantity = HKQuantity(unit: HKUnit(fromString: "count/min"), doubleValue: Double(arc4random_uniform(80) + 100))
    let heartSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, startDate: NSDate(), endDate: NSDate())
    
    // 2. Save the sample in the store
    healthKitStore.saveObject(heartSample, withCompletion: { (success, error) -> Void in
      if let error = error {
        print("Error saving heart sample: \(error.localizedDescription)")
      }
    })
  }
  
  static func startMockHeartData() {
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveMockHeartData", userInfo: nil, repeats: true)
  }
  
  static func stopMockHeartData() {
    self.timer?.invalidate()
  }
}
