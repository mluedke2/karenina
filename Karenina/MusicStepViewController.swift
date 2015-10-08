//
//  MusicStepViewController.swift
//  Karenina
//
//  Created by Matt Luedke on 10/2/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import AVFoundation
import ResearchKit

class MusicStepViewController: ORKActiveStepViewController {
  
  var audioPlayer: AVAudioPlayer?
  
  override func start() {
    super.start()
    
    if let step = step as? MusicStep {
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: step.clip.fileURL(), fileTypeHint: AVFileTypeMPEGLayer3)
        audioPlayer?.play()
      } catch {}
    }
  }
  
  override func stepDidFinish() {
    super.stepDidFinish()
    audioPlayer?.stop()
  }
}
