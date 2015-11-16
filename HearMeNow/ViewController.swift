//
//  ViewController.swift
//  HearMeNow
//
//  Created by Lawrence Martin on 11/12/15.
//  Copyright © 2015 Lawrence Martin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    let session = AVAudioSession.sharedInstance()
    
    var soundPath: String!
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    var hasRecording = false

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(sender: UIButton) {
        if soundRecorder.recording == true {
            soundRecorder.stop()
            mainLabel.text = "Recording has stopped.  \(soundPath)"
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            hasRecording = true
        } else {
            session.requestRecordPermission() {
                granted in
                if granted == true {
                    self.soundRecorder.record()
                    self.mainLabel.text = "Recording has started."
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                }
            }
        }
    }
    
    @IBAction func playPressed(sender: UIButton) {
        if soundPlayer.playing == true {
            soundPlayer.pause()
            mainLabel.text = "play is now paused"
            playButton.setTitle("Play", forState: UIControlState.Normal)
        } else if hasRecording == true {
            soundPlayer.play()
            mainLabel.text = "play is now going on"
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            hasRecording = false
        } // else {
//            soundPlayer.play()
//            mainLabel.text = "play without recording?"
//            playButton.setTitle("Pause", forState: UIControlState.Normal)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try session.setActive(true)
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                
                //soundPath.appendContentsOf("hearmenow.wav")
                soundPath = NSTemporaryDirectory() + "hearmenow.wav"
                let url = NSURL(fileURLWithPath: soundPath)
                do {
                    //let avSettings = [ AVFormatIDKey: "", AVSampleRateKey: "", AVNumberOfChannelsKey: 2 ]
                    let avSettings = [ AVNumberOfChannelsKey: 2 ]
                    soundRecorder = try AVAudioRecorder(URL: url, settings: avSettings )
                   
                    soundRecorder.delegate = self
                    soundRecorder.prepareToRecord()
                    do {
                        soundPlayer = try AVAudioPlayer(contentsOfURL: url)
                        soundPlayer.delegate = self
                        mainLabel.text = "YEAHHHH"
                    } catch {
                        mainLabel.text = "CATCH CATCH CATCH"
                    }

                } catch {
                    mainLabel.text = "CATCH CATCH CATCH"
                }
                
            } catch {
                mainLabel.text = "CATCH CATCH CATCH"
            }
        } catch {
            mainLabel.text = "CATCH CATCH CATCH"
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record Again", forState: UIControlState.Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.setTitle("Play Again", forState: UIControlState.Normal)
    }

}

