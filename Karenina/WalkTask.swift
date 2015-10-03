//
//  HeartTask.swift
//  Karenina
//
//  Created by Matt Luedke on 9/27/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import ResearchKit

public var WalkTask: ORKOrderedTask {
  return ORKOrderedTask.fitnessCheckTaskWithIdentifier("WalkTask",
    intendedUseDescription: nil,
    walkDuration: 15 as NSTimeInterval,
    restDuration: 15 as NSTimeInterval,
    options: .None)
}
