//
//  MusicTask.swift
//  Karenina
//
//  Created by Matt Luedke on 10/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import ResearchKit

public var MusicTask: ORKOrderedTask {
  
  var steps = [ORKStep]()
  
  let instructionStep = ORKInstructionStep(identifier: "intruction")
  instructionStep.title = "Music + Heart Rate"
  instructionStep.text = "Please listen to a randomized music clip for 30 seconds, and we'll record your heart rate."
  
  steps += [instructionStep]
  
  let configuration = ORKHealthQuantityTypeRecorderConfiguration(identifier: "heartRateConfig",
    healthQuantityType: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
    unit: HKUnit(fromString: "count/min"))
  
  let musicStep = MusicStep(identifier: "music")
  
  musicStep.clip = MusicClip.random()
  
  musicStep.stepDuration = 30
  musicStep.recorderConfigurations = [configuration]
  
  // a bunch of boilerplate configuration
  musicStep.shouldShowDefaultTimer = true
  musicStep.shouldStartTimerAutomatically = true
  musicStep.shouldContinueOnFinish = true
  musicStep.shouldPlaySoundOnStart = true
  musicStep.shouldPlaySoundOnFinish = true
  musicStep.shouldVibrateOnStart = true
  musicStep.shouldVibrateOnFinish = true
  musicStep.title = "Please listen for 30 seconds."
  
  steps += [musicStep]
  
  let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
  summaryStep.title = "Thank you!"
  summaryStep.text = "You have helped us research music and heart rate!"
  
  steps += [summaryStep]
  
  return ORKOrderedTask(identifier: "MusicTask", steps: steps)
}
