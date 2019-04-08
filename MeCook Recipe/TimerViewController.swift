//
//  TimerViewController.swift
//  MeCook Recipe
//
//  Created by Allan Shivji on 4/8/19.
//  Copyright © 2019 Allan Shivji. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var myComponentpicker: UIPickerView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
    var seconds = 0
    
    var hours = ""
    var minutes = ""
    
    var hoursArray:[String] = ["0 Hours", "1 Hours", "2 Hours", "3 Hours", "4 Hours", "5 Hours", "6 Hours", "7 Hours", "8 Hours", "9 Hours", "10 Hours", "11 Hours", "12 Hours"]
    
    var minutesArray:[String] = ["0 Min" ,"1 Min", "2 Min", "3 Min", "4 Min", "5 Min", "6 Min", "7 Min", "8 Min", "9 Min", "10 Min", "11 Min", "12 Min", "13 Min", "14 Min", "15 Min", "16 Min", "17 Min", "18 Min", "19 Min", "20 Min", "21 Min", "22 Min", "23 Min", "24 Min", "25 Min", "26 Min", "27 Min", "28 Min", "29 Min", "30 Min", "31 Min", "32 Min", "33 Min", "34 Min", "35 Min", "36 Min", "37 Min", "38 Min", "39 Min", "40 Min", "41 Min", "42 Min", "43 Min", "44 Min", "45 Min", "46 Min", "47 Min", "48 Min", "49 Min", "50 Min", "51 Min", "52 Min", "53 Min", "54 Min", "55 Min", "56 Min", "57 Min", "58 Min", "59 Min", "60 Min"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.isHidden = true

        myComponentpicker.dataSource = self
        myComponentpicker.delegate = self
        
        do {
            let audioPath = Bundle.main.path(forResource: "alarm", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            //ERROR
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return hoursArray.count
        }
        return minutesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return hoursArray[row]
        }
        return minutesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        hours = hoursArray[pickerView.selectedRow(inComponent: 0)]
        minutes = minutesArray[pickerView.selectedRow(inComponent: 1)]
        
        hoursLabel.text = "\(hours)"
        minutesLabel.text = "\(minutes)"
    }

    @IBAction func startButton(_ sender: Any) {
        
        timerLabel.isHidden = false
        runTimer()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        
        timer.invalidate()
        timerLabel.text = "0 Seconds"
        audioPlayer.stop()
        startBtn.isEnabled = true
    }
    
    func runTimer() {
        
        let splitHour = hours
        let splitMin = minutes
        
        let resultHour = splitHour.split(separator: " ")
        let resultMin = splitMin.split(separator: " ")
        
        let hh = Int(resultHour[0])!
        let mm = Int(resultMin[0])!
        
        seconds = ((hh * 60) + mm) * 60
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if seconds == 0 {
            timer.invalidate()
            startBtn.isEnabled = true
            audioPlayer.play()
        } else {
            seconds -= 1
        }
        timerLabel.text = "\(seconds) Seconds"
    }
}
