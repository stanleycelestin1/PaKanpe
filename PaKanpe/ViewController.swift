//
//  ViewController.swift
//  PaKanpe
//
//  Created by Stanley Celestin on 12/27/17.
//  Copyright © 2017 Stanley Celestin. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    var seconds = 60
    var timer   = Timer()
    var resumeTapped = false
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var Picker: UIDatePicker!
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var start: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Picker.countDownDuration = 60.0
        // set up audio
        do {
        
            try audioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do{
                  try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
            }
            catch{
                print (error)
            }
          
            
        }
        catch{
            print(error)
        }
        
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTimer(_ sender: UIButton) {
        
    //timerDisplay.text = "\(Picker.countDownDuration)"
        
        seconds = Int(Picker.countDownDuration)
        runTimer()
        start.isEnabled = false
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        if seconds == 56 {
            
            seconds = Int(Picker.countDownDuration)
            audioPlayer.currentTime = 0
           
            audioPlayer.play()
            
            
            
        } else {
        seconds -= 1     //This will decrement(count down)the seconds.
        }
        timerDisplay.text = timeString(time: TimeInterval(seconds))
        //This will update the label.
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
        }
    }
 
    @IBAction func resetTimer(_ sender: UIButton) {
        start.isEnabled = true
        timer.invalidate()
        
        seconds = 60    /* Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant. */
        timerDisplay.text = "00:00"
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
}

