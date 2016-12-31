//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Brenten Schlangen on 12/30/16.
//  Copyright © 2016 bschlangen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // disable stop-recording-button
        stopRecordingButton.isEnabled = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /******************************************************************************
     * recordAudio() 
     *
     * Record audio and set record/audio buttons to represent that recording
     * has started.
     ******************************************************************************/
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        // Setup the path for audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // Setup an audio session
        let session = AVAudioSession.sharedInstance()
        // Don't handle error
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        // Attempt to setup the audio recorder, and begin recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print("began recording")
    }

    /******************************************************************************
     * stopRecording()
     *
     * Stop recording audio and reset the record/stop buttons
     ******************************************************************************/
    @IBAction func stopRecording(_ sender: Any) {
        
        // Enable/Disable the recording buttons
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print("stop recording")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("finished recording")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)

        } else {
            print("Recording was unsuccessful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

