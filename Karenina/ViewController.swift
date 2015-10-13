//
//  ViewController.swift
//  Karenina
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import AVFoundation
import ResearchKit

class ViewController: UIViewController {
  
  var audioPlayer: AVAudioPlayer?
  var soundFileURL: NSURL?
  
  @IBAction func consentTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
    taskViewController.delegate = self
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func surveyTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: SurveyTask(), taskRunUUID: nil)
    taskViewController.delegate = self
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func microphoneTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRunUUID: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func playMostRecentSound(sender: AnyObject) {
    if let soundFileURL = soundFileURL {
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL, fileTypeHint: AVFileTypeAppleM4A)
        audioPlayer?.play()
      } catch {}
    }
  }
  
  @IBAction func walkTapped(sender: AnyObject) {
    let taskViewController = ORKTaskViewController(task: WalkTask, taskRunUUID: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
    presentViewController(taskViewController, animated: true, completion: nil)
    HealthKitManager.startMockHeartData()
  }
  
  @IBAction func musicTapped(sender: AnyObject) {
    let taskViewController = ORKTaskViewController(task: MusicTask, taskRunUUID: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
    presentViewController(taskViewController, animated: true, completion: nil)
    HealthKitManager.startMockHeartData()
  }
  
  @IBAction func authorize(sender: AnyObject) {
    HealthKitManager.authorizeHealthKit()
  }
}

extension ViewController: ORKTaskViewControllerDelegate {

  func taskViewController(taskViewController: ORKTaskViewController, viewControllerForStep step: ORKStep) -> ORKStepViewController? {
    
    if step.identifier == "music" {
      return MusicStepViewController(step: step)
    } else {
      return nil
    }
  }
  
  func taskViewController(taskViewController: ORKTaskViewController,
    didFinishWithReason reason: ORKTaskViewControllerFinishReason,
    error: NSError?) {
    
    if (taskViewController.task?.identifier == "MusicTask"
      && reason == .Completed) {
        
      let clip = ResultParser.findClip(taskViewController.task)
      print("clip name: \(clip?.rawValue)")
        
      let heartURL = ResultParser.findMusicHeartFiles(taskViewController.result)
      if let heartURL = heartURL {
        do {
          let string = try NSString.init(contentsOfURL: heartURL, encoding: NSUTF8StringEncoding)
          print(string)
        } catch {}
      }
    }
    
    HealthKitManager.stopMockHeartData()
    
    if (taskViewController.task?.identifier == "AudioTask"
      && reason == .Completed) {
      soundFileURL = ResultParser.findSoundFile(taskViewController.result)
    }
    
    if (taskViewController.task?.identifier == "WalkTask"
      && reason == .Completed) {
        
      let heartURLs = ResultParser.findWalkHeartFiles(taskViewController.result)
      
      for url in heartURLs {
        do {
          let string = try NSString.init(contentsOfURL: url, encoding: NSUTF8StringEncoding)
          print(string)
        } catch {}
      }
    }
    
    if (reason != .Failed) {
      taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}
