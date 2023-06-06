//
//  ViewModel.swift
//  StepCounter
//
//  Created by suhemparashar on 06/06/23.
//

import Foundation
import HealthKit

protocol Delegate {
    func stepCountFetched(stepCount: Int)
}

class ViewModel {
    
    let healthStore = HKHealthStore()
    
    var delegate: Delegate? = nil
    
    func authorizeHealthKit() {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }
        
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let typesToRead: Set<HKObjectType> = [stepCountType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            } else if success {
                print("HealthKit authorization granted.")
                self.fetchStepCount()
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }
    
    func fetchStepCount() {
        
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            if let result = result, let sum = result.sumQuantity() {
                let stepCount = sum.doubleValue(for: HKUnit.count())
                
                self.delegate?.stepCountFetched(stepCount: Int(stepCount))
        
            } else if let error = error {
                print("Error querying step count: \(error.localizedDescription)")
            }
        }
        
        healthStore.execute(query)
    }
}
