//  Beat The Block
//  ViewController.swift

import UIKit
import AudioKit

// MARK:- MAIN SCREEN VIEW CONTROLLER -

public var fxAudioPlayer: FXAudioPlayer!
// Declare variable to check whether the view has been loaded for the first time
var firstTime = true
// Declare variable to check whether the user has been alerted to a particular warning
var alerted = false

class ViewController: UIViewController {

    /* Outlets for all sliders, labels, steppers and segments on the main View Controller */
    @IBOutlet var octaveStepperLabel: UILabel!
    @IBOutlet var metronomeTempoSlider: UISlider!
    @IBOutlet var metronomeTempoLabel: UILabel!
    @IBOutlet var synthArmSegment: UISegmentedControl!
    @IBOutlet var drumsArmSegment: UISegmentedControl!
    @IBOutlet var micArmSegment: UISegmentedControl!
    @IBOutlet var instrumentStepper: UIStepper!
    @IBOutlet var instrumentNameLabel: UILabel!
    @IBOutlet var octaveStepper: UIStepper!
    @IBOutlet var beatsPerBarStepper: UIStepper!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var decayLabel: UILabel!
    @IBOutlet var sustainLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var velocityValueLabel: UILabel!
    @IBOutlet var velocityValueSlider: UISlider!
    @IBOutlet var drumsVolumeLabel: UILabel!
    @IBOutlet var synthVolumeLabel: UILabel!
    @IBOutlet var micVolumeLabel: UILabel!
    @IBOutlet var vibratoRateSlider: UISlider!
    @IBOutlet var vibratoRateLabel: UILabel!
    @IBOutlet var vibratoDepthSlider: UISlider!
    @IBOutlet var vibratoDepthLabel: UILabel!
    // Create a pitch bend slider that is vertical and not horizontal
    @IBOutlet var pitchBendSlider: UISlider! {
        didSet{
            pitchBendSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    @IBOutlet var pitchBendLabel: UILabel!
    
    // A string to store the names of the wave shapes we will be using for the synthesiser
    var synthSounds = ["Sine", "Sawtooth", "Triangle", "Square"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // If the view has already been loaded, so create another instance of FXAudioPlayer
        if firstTime == true {
            firstTime = false
            fxAudioPlayer = FXAudioPlayer()
        }
        // Instantiate some UI control properties before moving on.
        beatsPerBarStepper.value = Double(Int(fxAudioPlayer.metronome.subdivision))
        instrumentStepper.maximumValue = 3
    }
    
   
    
    // A method to begin or stop the metronome
    @IBAction func toggleMetronome(_ sender: UIButton) {
       // If it's playing, stop it and bring it back to the first beat
        if fxAudioPlayer.metronome.isPlaying {
            fxAudioPlayer.metronome.stop()
            fxAudioPlayer.metronome.reset()
        }
        // If it isn't playing, start it
        else {
            fxAudioPlayer.metronome.start()
        }
    }
    
    // A method to set the pitch bend of the synthesiser, regardless of what waveshape it is using
    @IBAction func setPitchBend(_ sender: UISlider) {
        fxAudioPlayer.sineSynth.pitchBend = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.pitchBend = Double(sender.value)
        fxAudioPlayer.fmSynth.pitchBend = Double(sender.value)
        fxAudioPlayer.squareSynth.pitchBend = Double(sender.value)
        pitchBendLabel.text = String(format: "%0.2f", pitchBendSlider.value)
    }
    
    // A method to allow the user to reset pitch bend to zero in case the slider doesn't go back to zero
    @IBAction func resetPitchBend(_ sender: UIButton) {
        fxAudioPlayer.sineSynth.pitchBend = 0
        fxAudioPlayer.sawtoothSynth.pitchBend = 0
        fxAudioPlayer.fmSynth.pitchBend = 0
        fxAudioPlayer.squareSynth.pitchBend = 0
        pitchBendSlider.value = 0
        pitchBendLabel.text = String(format: "%0.2f", 0)
        
    }
    // A function to set the vibrate rate of the synthesiser
    @IBAction func setVibratoRate(_ sender: UISlider) {
        fxAudioPlayer.sineSynth.vibratoRate = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.vibratoRate = Double(sender.value)
        fxAudioPlayer.fmSynth.vibratoRate = Double(sender.value)
        fxAudioPlayer.squareSynth.vibratoRate = Double(sender.value)
        vibratoRateLabel.text = String(format: "%0.2f", sender.value)
        
    }
    // A method to allow the user to reset the vibrato rate if the slider doesn't return to zero
    @IBAction func resetVibratoRate(_ sender: UIButton) {
        fxAudioPlayer.sineSynth.vibratoRate = 0
        fxAudioPlayer.sawtoothSynth.vibratoRate = 0
        fxAudioPlayer.fmSynth.vibratoRate = 0
        fxAudioPlayer.squareSynth.vibratoRate = 0
        vibratoRateSlider.value = 0
        vibratoRateLabel.text = String(format: "%0.2f", 0)
    }
    // A method to set the vibrate depth of the synthesiser
    @IBAction func setVibratoDepth(_ sender: UISlider) {
       fxAudioPlayer.sineSynth.vibratoDepth = Double(sender.value)
       fxAudioPlayer.sawtoothSynth.vibratoDepth = Double(sender.value)
       fxAudioPlayer.fmSynth.vibratoDepth = Double(sender.value)
       fxAudioPlayer.squareSynth.vibratoDepth = Double(sender.value)
       vibratoDepthLabel.text = String(format: "%0.2f", sender.value)
        
    }
    // A method to allow the user to reset the vibrato depth if the slider doesn't return to zero
    @IBAction func resetVibratoDepth(_ sender: UIButton) {
        fxAudioPlayer.sineSynth.vibratoDepth = 0
        fxAudioPlayer.sawtoothSynth.vibratoDepth = 0
        fxAudioPlayer.fmSynth.vibratoDepth = 0
        fxAudioPlayer.squareSynth.vibratoDepth = 0
        vibratoDepthSlider.value = 0
        vibratoDepthLabel.text = String(format: "%0.2f", 0)
    }
    
    
    
    // Make sure that only one instrument can be armed at a time
    @IBAction func armSynthSegment (_ sender: UISegmentedControl) {
        if synthArmSegment.selectedSegmentIndex == 1 {
            drumsArmSegment.selectedSegmentIndex = 0
            micArmSegment.selectedSegmentIndex = 0
            fxAudioPlayer.microphone.volume = 0
        }
        
        
    }
    // Make sure that only one instrument can be armed at a time
    @IBAction func armDrumsSegment(_ sender: UISegmentedControl) {
        if drumsArmSegment.selectedSegmentIndex == 1 {
            synthArmSegment.selectedSegmentIndex = 0
            micArmSegment.selectedSegmentIndex = 0
            fxAudioPlayer.microphone.volume = 0
        }
    }
    // Make sure that only one instrument can be armed at a time
    @IBAction func armMicSegment(_ sender: UISegmentedControl) {
        if micArmSegment.selectedSegmentIndex == 1 {
            synthArmSegment.selectedSegmentIndex = 0
            drumsArmSegment.selectedSegmentIndex = 0
            if alerted == true {
                // If warning alert has been shown, allow microphone's volume to turn up
                fxAudioPlayer.microphone.volume = 0.5
            }
        } else {
            // If the user hasn't been warned, keep volume down to avoid feedback
            fxAudioPlayer.microphone.volume = 0
        }
    }
    // Unarm the microphone and set its volume to zero
    @IBAction func disarmMicSegment(_ sender: UISegmentedControl) {
        if micArmSegment.selectedSegmentIndex == 0 {
            fxAudioPlayer.microphone.volume = 0
        }
    }
    
    // A method to set the BPM of the metronome
    @IBAction func setMetronomeTempo(_ sender: UISlider) {
        fxAudioPlayer.metronome.tempo = Double(sender.value)
        metronomeTempoLabel.text = String(format: "%0.0f", metronomeTempoSlider.value)
        
    }
    // A method to choose the amount of beats per bar that the metronome counts
    @IBAction func setTimeSignature(_ sender: UIStepper) {
        fxAudioPlayer.metronome.subdivision = Int(sender.value)
    }
    
    // A method to increase or decrease the octaves on the synthesiser
    @IBAction func octaveStep(_ sender: UIStepper) {
        octaveStepperLabel.text = String(format: "%0.0f", sender.value)
    }
    // A method to choose which synthesiser sound is wanted
    @IBAction func chooseInstrument(_ sender: UIStepper) {
        switch sender.value {
        case 0: instrumentNameLabel.text = String(synthSounds[0])
        case 1: instrumentNameLabel.text = String(synthSounds[1])
        case 2: instrumentNameLabel.text = String(synthSounds[2])
        case 3: instrumentNameLabel.text = String(synthSounds[3])
        default: instrumentNameLabel.text = String(synthSounds[0])
        }
    }
    
    // A method to set the midi velocity of the keys on the synthesiser
    @IBAction func setVelocity(_ sender: UISlider) {
        velocityValueLabel.text = String(format: "%0.0f", sender.value)
    }
    
    // A method that will register when a synthesiser button is pressed, and play the corresponding note at the corresponding octave and velocity - also on the correct instrument
    @IBAction func notePressed(_ sender: UIButton) {
        switch sender.tag {
            // Play the note, but also change the colour of the button for better visual aid
        case 1: fxAudioPlayer.playC(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 2: fxAudioPlayer.playCSharp(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 3: fxAudioPlayer.playD(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 4: fxAudioPlayer.playDSharp(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 5: fxAudioPlayer.playE(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 6: fxAudioPlayer.playF(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 7: fxAudioPlayer.playFSharp(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 8: fxAudioPlayer.playG(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 9: fxAudioPlayer.playGSharp(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 10: fxAudioPlayer.playA(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 11: fxAudioPlayer.playASharp(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 12: fxAudioPlayer.playB(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            case 13: fxAudioPlayer.playCHigh(Int(octaveStepper!.value), Int(velocityValueSlider.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.lightGray
            default: print("Default")
        }
    }
    // A method to detect when a synthesiser button has been released, and hence when the note can turn off
    @IBAction func noteReleased(_ sender: UIButton) {
        switch sender.tag {
            // Stop the note, but also return the button to its original colour
        case 1: fxAudioPlayer.stopC(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 2: fxAudioPlayer.stopCSharp(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.black
            case 3: fxAudioPlayer.stopD(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 4: fxAudioPlayer.stopDSharp(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.black
            case 5: fxAudioPlayer.stopE(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 6: fxAudioPlayer.stopF(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 7: fxAudioPlayer.stopFSharp(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.black
            case 8: fxAudioPlayer.stopG(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 9: fxAudioPlayer.stopGSharp(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.black
            case 10: fxAudioPlayer.stopA(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 11: fxAudioPlayer.stopASharp(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.black
            case 12: fxAudioPlayer.stopB(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
            case 13: fxAudioPlayer.stopCHigh(Int(octaveStepper!.value), Int(instrumentStepper!.value))
            sender.backgroundColor = UIColor.white
        default: print("Default")
        }
    }
    // A method to detect when a sample pad on the drum machine has been pressed so that the corresponding sample file can be played
    @IBAction func drumkitPressed(_ sender: UIButton) {
        switch(sender.tag) {
            // Play the sample, but also change the button's colour for better visual aid
        case 0: if fxAudioPlayer.kickPlayer.isPlaying {
                    fxAudioPlayer.kickTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.kickPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
        
            
        case 1: if fxAudioPlayer.snarePlayer.isPlaying {
                    fxAudioPlayer.snareTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.snarePlayer.play(from: 0.015)
                    sender.backgroundColor = UIColor.systemPink
                }
            
        case 2: if fxAudioPlayer.openHiHatPlayer.isPlaying {
                   fxAudioPlayer.openHiHatTwoPlayer.play()
                   sender.backgroundColor = UIColor.systemPink
                } else {
                   fxAudioPlayer.openHiHatPlayer.play()
                   sender.backgroundColor = UIColor.systemPink
                }
            
        case 3: if fxAudioPlayer.closedHiHatPlayer.isPlaying {
                    fxAudioPlayer.closedHiHatTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.closedHiHatPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
            
        case 4: if fxAudioPlayer.crashPlayer.isPlaying {
                    fxAudioPlayer.crashTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.crashPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }

        case 5: if fxAudioPlayer.ridePlayer.isPlaying {
                    fxAudioPlayer.rideTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.ridePlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
            
        case 6: if fxAudioPlayer.highTomPlayer.isPlaying {
                    fxAudioPlayer.highTomTwoPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.highTomPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
            
        case 7: if fxAudioPlayer.midTomPlayer.isPlaying {
                fxAudioPlayer.midTomTwoPlayer.play()
                sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.midTomPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
        case 8: if fxAudioPlayer.lowTomPlayer.isPlaying {
                fxAudioPlayer.lowTomTwoPlayer.play()
                sender.backgroundColor = UIColor.systemPink
                } else {
                    fxAudioPlayer.lowTomPlayer.play()
                    sender.backgroundColor = UIColor.systemPink
                }
        default: print("nothing played")
        }
    }
    // When the sample pad button has been released, return the button to its original colour
    @IBAction func drumkitReleased(_ sender: UIButton) {
        switch sender.tag {
            case 0: sender.backgroundColor = UIColor.opaqueSeparator
            case 1: sender.backgroundColor = UIColor.opaqueSeparator
            case 2: sender.backgroundColor = UIColor.opaqueSeparator
            case 3: sender.backgroundColor = UIColor.opaqueSeparator
            case 4: sender.backgroundColor = UIColor.opaqueSeparator
            case 5: sender.backgroundColor = UIColor.opaqueSeparator
            case 6: sender.backgroundColor = UIColor.opaqueSeparator
            case 7: sender.backgroundColor = UIColor.opaqueSeparator
            case 8: sender.backgroundColor = UIColor.opaqueSeparator
        default: sender.backgroundColor = UIColor.opaqueSeparator
        }
    }
    // A method to set the attack of the ADSR envelope for the synthesiser
    @IBAction func setAttack(_ sender: UISlider) {
        fxAudioPlayer.fmSynth.attackDuration = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.attackDuration = Double(sender.value)
        fxAudioPlayer.sineSynth.attackDuration = Double(sender.value)
        fxAudioPlayer.squareSynth.attackDuration = Double(sender.value)
        
        attackLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the Decay of the ADSR envelope for the synthesiser
    @IBAction func setDecay(_ sender: UISlider) {
        fxAudioPlayer.fmSynth.decayDuration = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.decayDuration = Double(sender.value)
        fxAudioPlayer.sineSynth.decayDuration = Double(sender.value)
        fxAudioPlayer.squareSynth.decayDuration = Double(sender.value)
        
        decayLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the sustain of the ADSR envelope for the synthesiser
    @IBAction func setSustain(_ sender: UISlider) {
        fxAudioPlayer.fmSynth.sustainLevel = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.sustainLevel = Double(sender.value)
        fxAudioPlayer.sineSynth.sustainLevel = Double(sender.value)
        fxAudioPlayer.squareSynth.sustainLevel = Double(sender.value)
        
        sustainLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the release time of the ADSR envelope for the synthesiser
    @IBAction func setRelease(_ sender: UISlider) {
        fxAudioPlayer.fmSynth.releaseDuration = Double(sender.value)
        fxAudioPlayer.sawtoothSynth.releaseDuration = Double(sender.value)
        fxAudioPlayer.sineSynth.releaseDuration = Double(sender.value)
        fxAudioPlayer.squareSynth.releaseDuration = Double(sender.value)
        
        releaseLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the volume of the synthesiser mixer
    @IBAction func setSynthVolume(_ sender: UISlider) {
        fxAudioPlayer.keyboardMixer.volume = Double(sender.value)
        synthVolumeLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the volume of the drum machine's mixer
    @IBAction func setDrumsVolume(_ sender: UISlider) {
        fxAudioPlayer.drumMixer.volume = Double(sender.value)
        drumsVolumeLabel.text = String(format: "%0.2f", sender.value)
    }
    // A method to set the volume of the microphone's mixer
    @IBAction func setMicVolume(_ sender: UISlider) {
        fxAudioPlayer.microphoneMixer.volume = Double(sender.value)
        micVolumeLabel.text = String(format: "%0.2f", sender.value)
    }
    
    // A method to show an alert to user that the microphone can feedback if used with internal speakers. Headphones are recommended in the message.
    @IBAction func showAlert(_ sender: UISegmentedControl) {
        //fxAudioPlayer.microphone.volume = 0.0
        let alertController = UIAlertController(title: "Warning!", message:
        "Please use headphones!\nArming the microphone whilst using your device's built in speaker may result in a feedback loop.", preferredStyle: .alert)
        // If they have been alerted before during this app run, send them a warning message when they try to arm the microphone
        if alerted == false {
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            if sender.selectedSegmentIndex == 1 {
                // Pull the segment display back to 0 until they have seen the warning
                sender.selectedSegmentIndex = 0
               self.present(alertController, animated: true, completion: nil)
               
            } else {
                sender.selectedSegmentIndex = 0
            }
        }
        // The user has now been alerted to the microphone warning
        alerted = true
    }
    
    
    
    
    

    // MARK: - RECORDING FUNCTIONALITY -
    // A function to play back all possible drum recordings
    func drumPlayback() {

        // If first drum recorder has been recorded to, play it back
        if fxAudioPlayer.drumsOneRecorder.recordedDuration > 0 {
            try! fxAudioPlayer.drumsOnePlayer.reloadFile()
            fxAudioPlayer.drumsOnePlayer.start()
            // If second drum recorder has been recorded to, play it back
            if fxAudioPlayer.drumsTwoRecorder.recordedDuration > 0 {
                try! fxAudioPlayer.drumsTwoPlayer.reloadFile()
                fxAudioPlayer.drumsTwoPlayer.start()
                // If third drum recorder has been recorded to, play it back
                if fxAudioPlayer.drumsThreeRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.drumsThreePlayer.reloadFile()
                    fxAudioPlayer.drumsThreePlayer.start()
                    // If fourth drum recorder has been recorded to, play it back
                    if fxAudioPlayer.drumsFourRecorder.recordedDuration > 0 {
                        try! fxAudioPlayer.drumsFourPlayer.reloadFile()
                        fxAudioPlayer.drumsFourPlayer.start()
                    }
                }
            }
        }
    }
    
    func micPlayback() {
        // If first mic recorder has been recorded to, play it back
        if fxAudioPlayer.micOneRecorder.recordedDuration > 0 {
            try! fxAudioPlayer.micOnePlayer.reloadFile()
            fxAudioPlayer.micOnePlayer.start()
            // If second mic recorder has been recorded to, play it back
            if fxAudioPlayer.micTwoRecorder.recordedDuration > 0{
                try! fxAudioPlayer.micTwoPlayer.reloadFile()
                fxAudioPlayer.micTwoPlayer.start()
                // If third mic recorder has been recorded to, play it back
                if fxAudioPlayer.micThreeRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.micThreePlayer.reloadFile()
                fxAudioPlayer.micThreePlayer.start()
                    // If fourth mic recorder has been recorded to, play it back
                    if fxAudioPlayer.micFourRecorder.recordedDuration > 0 {
                        try! fxAudioPlayer.micFourPlayer.reloadFile()
                    fxAudioPlayer.micFourPlayer.start()
                    }
                }
            }
        }
    }
    
    func synthPlayback() {
        // If first synth recorder has been recorded to, play it back
        if fxAudioPlayer.synthOneRecorder.recordedDuration > 0 {
            try! fxAudioPlayer.synthOnePlayer.reloadFile()
            fxAudioPlayer.synthOnePlayer.start()
            // If second synth recorder has been recorded to, play it back
            if fxAudioPlayer.synthTwoRecorder.recordedDuration > 0 {
                try! fxAudioPlayer.synthTwoPlayer.reloadFile()
                fxAudioPlayer.synthTwoPlayer.start()
                // If third synth recorder has been recorded to, play it back
                if fxAudioPlayer.synthThreeRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.synthThreePlayer.reloadFile()
                fxAudioPlayer.synthThreePlayer.start()
                     // If fourth synth recorder has been recorded to, play it back
                    if fxAudioPlayer.synthFourRecorder.recordedDuration > 0 {
                        try! fxAudioPlayer.synthFourPlayer.reloadFile()
                    fxAudioPlayer.synthFourPlayer.start()
                    }
                }
            }
        }
        
    }

    // A method to record the output from the synthesiser on 4 separate occassions
    @IBAction func recordSynthButton(_ sender: UIButton) {
        // Change button colour on press for visual aid
        sender.backgroundColor = UIColor.opaqueSeparator
        
        // If the synthesiser is armed for recording then we can record
        if synthArmSegment.selectedSegmentIndex == 1 {
        // If first player isn't recording and has nothing written to file, record on first synth recorder
            if fxAudioPlayer.synthOneRecorder.isRecording == false && fxAudioPlayer.synthOneRecorder.recordedDuration == 0 {
                try! fxAudioPlayer.synthOneRecorder.record()
                // Playback the drums and microphone (if they have been recorded to) whilst the synth is being recorded
                drumPlayback()
                micPlayback()
            } else {
                // Stop the recording if already recording to avoid crash
                fxAudioPlayer.synthOneRecorder.stop()
            }
            // If second player isn't recording and first recording has been written to, record on second recorder
            if fxAudioPlayer.synthTwoRecorder.isRecording == false && fxAudioPlayer.synthOneRecorder.recordedDuration != 0 {
                // Let previous files playback during recording
                try! fxAudioPlayer.synthTwoRecorder.record()
                try! fxAudioPlayer.synthOnePlayer.reloadFile()
                fxAudioPlayer.synthOnePlayer.start()
                // Playback the drums and microphone (if they have been recorded to) whilst the synth is being recorded
                drumPlayback()
                micPlayback()
            } else {
                fxAudioPlayer.synthTwoRecorder.stop()
            }
            // If third player isn't recording and second has something written to file, record on third synth recorder
            if fxAudioPlayer.synthThreeRecorder.isRecording == false && fxAudioPlayer.synthTwoRecorder.recordedDuration != 0 {

                // Let previous file(s) playback during recording
                try! fxAudioPlayer.synthTwoPlayer.reloadFile()
                fxAudioPlayer.synthOnePlayer.start()
                fxAudioPlayer.synthTwoPlayer.start()
                // Playback the drums and microphone (if they have been recorded to) whilst the synth is being recorded
                drumPlayback()
                micPlayback()
                // Remove tap to allow further recordings to take place
                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 0)
                try! fxAudioPlayer.synthThreeRecorder.record()
                
            } else {
                fxAudioPlayer.synthThreeRecorder.stop()
            }
            // If fourth player isn't recording and third recorder has been written to, record on fourth recorder
            if fxAudioPlayer.synthFourRecorder.isRecording == false && fxAudioPlayer.synthThreeRecorder.recordedDuration != 0 {
                // Let previous file(s) playback during recording

                try! fxAudioPlayer.synthThreePlayer.reloadFile()
                fxAudioPlayer.synthOnePlayer.start()
                fxAudioPlayer.synthTwoPlayer.start()
                fxAudioPlayer.synthThreePlayer.start()
                // Playback the drums and microphone (if they have been recorded to) whilst the synth is being recorded
                micPlayback()
                drumPlayback()

                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 3)
                try! fxAudioPlayer.synthFourRecorder.record()
            }
        } else {
            fxAudioPlayer.synthFourRecorder.stop()
        }

    }
    // Change the colour of the record button back when let go
    @IBAction func recordButtonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemRed
    }
    

    // A method to record the output from the drum machine on 4 separate occassions
    @IBAction func recordDrumsButton(_ sender: UIButton) {
        // Change the colour of the button for visual aid
        sender.backgroundColor = UIColor.opaqueSeparator
        // If drums are armed, they can be recorded
        if drumsArmSegment.selectedSegmentIndex == 1 {
            // If first player isn't recording and first recorder hasn't been written to, record on first recorder
            if fxAudioPlayer.drumsOneRecorder.isRecording == false && fxAudioPlayer.drumsOneRecorder.recordedDuration == 0 {
                try! fxAudioPlayer.drumsOneRecorder.record()
                // Playback the synthesiser and microphone (if they have been recorded to) whilst the drum is being recorded
                micPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.drumsOneRecorder.stop()
            }
            // If second player isn't recording and first recorder has been written to, record on second recorder
            if fxAudioPlayer.drumsTwoRecorder.isRecording == false && fxAudioPlayer.drumsOneRecorder.recordedDuration != 0 {
                // Play back previous drum recordings whilst new recording is taking place
                try! fxAudioPlayer.drumsTwoRecorder.record()
                try! fxAudioPlayer.drumsOnePlayer.reloadFile()
                fxAudioPlayer.drumsOnePlayer.start()
                // Playback the synthesiser and microphone (if they have been recorded to) whilst the drum is being recorded
                micPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.drumsTwoRecorder.stop()
            }
            // If third player isn't recording and second recorder has been written to, record on third recorder
            if fxAudioPlayer.drumsThreeRecorder.isRecording == false && fxAudioPlayer.drumsTwoRecorder.recordedDuration != 0 {
                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 0)
                // Play back previous drum recordings whilst new recording is taking place
                try! fxAudioPlayer.drumsThreeRecorder.record()
                //try! fxAudioPlayer.drumsOnePlayer.reloadFile()
                try! fxAudioPlayer.drumsTwoPlayer.reloadFile()
                fxAudioPlayer.drumsOnePlayer.start()
                fxAudioPlayer.drumsTwoPlayer.start()
                // Playback the synthesiser and microphone (if they have been recorded to) whilst the drum is being recorded
                micPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.drumsThreeRecorder.stop()
            }
            // If fourth player isn't recording and third recorder has been written to, record on fourth recorder
            if fxAudioPlayer.drumsFourRecorder.isRecording == false && fxAudioPlayer.drumsThreeRecorder.recordedDuration != 0 {
                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 0)
                // Play back previous drum recordings whilst new recording is taking place
                try! fxAudioPlayer.drumsFourRecorder.record()
                try! fxAudioPlayer.drumsThreePlayer.reloadFile()
                fxAudioPlayer.drumsOnePlayer.start()
                fxAudioPlayer.drumsTwoPlayer.start()
                fxAudioPlayer.drumsThreePlayer.start()
                // Playback the synthesiser and microphone (if they have been recorded to) whilst the drums are being recorded
                micPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.drumsFourRecorder.stop()
            }
            
        }
        
    }
    // A function to record the microphone on four separate occassions
    @IBAction func recordMicrophoneButton(_ sender: UIButton) {
        // Change the button colour on press down
        sender.backgroundColor = UIColor.opaqueSeparator
        // If microphone is armed, it can be recorded
        if micArmSegment.selectedSegmentIndex == 1 {
            // Set volume just in case it was left on 0
            fxAudioPlayer.microphone.volume = 0.5
            // If first player isn't recording and first recorder hasn't been written to, record on first recorder
            if fxAudioPlayer.micOneRecorder.isRecording == false && fxAudioPlayer.micOneRecorder.recordedDuration == 0 {
                try! fxAudioPlayer.micOneRecorder.record()
                // Playback the synthesiser and drums (if they have been recorded to) whilst the mic is being recorded
                drumPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.micOneRecorder.stop()
            }
            
            // If second player isn't recording and first recorder has been written to, record on second recorder
            if fxAudioPlayer.micTwoRecorder.isRecording == false && fxAudioPlayer.micOneRecorder.recordedDuration != 0 {
                // Let previous file playback during recording
                try! fxAudioPlayer.micTwoRecorder.record()
                try! fxAudioPlayer.micOnePlayer.reloadFile()
                fxAudioPlayer.micOnePlayer.start()
                // Playback the synthesiser and drums (if they have been recorded to) whilst the mic is being recorded
                drumPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.micTwoRecorder.stop()
            }
            // If third player isn't recording and second recorder has been written to, record on third recorder
            if fxAudioPlayer.micThreeRecorder.isRecording == false && fxAudioPlayer.micTwoRecorder.recordedDuration != 0 {
                // Let previous file(s) playback during recording
                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 0)
                try! fxAudioPlayer.micThreeRecorder.record()
                try! fxAudioPlayer.micTwoPlayer.reloadFile()
                fxAudioPlayer.micOnePlayer.start()
                fxAudioPlayer.micTwoPlayer.start()
                // Playback the synthesiser and drums (if they have been recorded to) whilst the mic is being recorded
                drumPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.micThreeRecorder.stop()
            }
            // If fourth player isn't recording and third recorder has been written to, record on fourth recorder
            if fxAudioPlayer.micFourRecorder.isRecording == false && fxAudioPlayer.micThreeRecorder.recordedDuration != 0 {
                // Let previous file(s) playback during recording
                fxAudioPlayer.recordingMixer.inputNode.removeTap(onBus: 0)
                try! fxAudioPlayer.micFourRecorder.record()
                try! fxAudioPlayer.micThreePlayer.reloadFile()
                fxAudioPlayer.micOnePlayer.start()
                fxAudioPlayer.micTwoPlayer.start()
                fxAudioPlayer.micThreePlayer.start()
                // Playback the synthesiser and drums (if they have been recorded to) whilst the mic is being recorded
                drumPlayback()
                synthPlayback()
            } else {
                fxAudioPlayer.micFourRecorder.stop()
            }
            
        } else {
            print("Must arm micropohone for recording")
        }
    }
    // A method to stop the recordings
    @IBAction func stopRecordingButton(_ sender: UIButton) {
        // Change button colour on down press
        sender.backgroundColor = UIColor.opaqueSeparator
        // Stop the synthesiser recording
        if fxAudioPlayer.synthFourRecorder.isRecording {
            fxAudioPlayer.synthFourRecorder.stop()
        }
        if fxAudioPlayer.synthThreeRecorder.isRecording {
            fxAudioPlayer.synthThreeRecorder.stop()
        }
        if fxAudioPlayer.synthTwoRecorder.isRecording {
            fxAudioPlayer.synthTwoRecorder.stop()
        }
        if fxAudioPlayer.synthOneRecorder.isRecording {
            fxAudioPlayer.synthOneRecorder.stop()
        }
        // Stop the drum recordings
        if fxAudioPlayer.drumsOneRecorder.isRecording {
            fxAudioPlayer.drumsOneRecorder.stop()
        }
        if fxAudioPlayer.drumsTwoRecorder.isRecording {
            fxAudioPlayer.drumsTwoRecorder.stop()
        }
        if fxAudioPlayer.drumsThreeRecorder.isRecording {
            fxAudioPlayer.drumsThreeRecorder.stop()
        }
        if fxAudioPlayer.drumsFourRecorder.isRecording {
            fxAudioPlayer.drumsFourRecorder.stop()
        }
        
        // Stop the microphone recordings
        if fxAudioPlayer.micOneRecorder.isRecording {
            fxAudioPlayer.micOneRecorder.stop()
            fxAudioPlayer.microphone.volume = 0
        }
        if fxAudioPlayer.micTwoRecorder.isRecording {
            fxAudioPlayer.micTwoRecorder.stop()
            fxAudioPlayer.microphone.volume = 0
        }
        if fxAudioPlayer.micThreeRecorder.isRecording {
            fxAudioPlayer.micThreeRecorder.stop()
            fxAudioPlayer.microphone.volume = 0
        }
        if fxAudioPlayer.micFourRecorder.isRecording {
            fxAudioPlayer.micFourRecorder.stop()
            fxAudioPlayer.microphone.volume = 0
        }
    
    }
    
    // Change button back to original colour
    @IBAction func stopButtonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemPurple
    }
    
    
    // Play the recording back to user
    @IBAction func playbackButton(_ sender: UIButton) {
        // Change button colour
        sender.backgroundColor = UIColor.opaqueSeparator
        // Play all three instruments' recordings back simultaneously (and hopefully in time)
        synthPlayback()
        drumPlayback()
        micPlayback()
    }
    // Change button back to original colour
    @IBAction func playButtonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemGreen
    }
    
    // A function to allow the user to pause the playback
    @IBAction func pauseButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.opaqueSeparator
        fxAudioPlayer.synthOnePlayer.stop()
        fxAudioPlayer.synthTwoPlayer.stop()
        fxAudioPlayer.synthThreePlayer.stop()
        fxAudioPlayer.synthFourPlayer.stop()
        fxAudioPlayer.drumsOnePlayer.stop()
        fxAudioPlayer.drumsTwoPlayer.stop()
        fxAudioPlayer.drumsThreePlayer.stop()
        fxAudioPlayer.drumsFourPlayer.stop()
        fxAudioPlayer.micOnePlayer.stop()
        fxAudioPlayer.micTwoPlayer.stop()
        fxAudioPlayer.micThreePlayer.stop()
        fxAudioPlayer.micFourPlayer.stop()
    }
    // Change button back to original colour
    @IBAction func pauseButtonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemYellow
    }
    
    
    
    // A method to allow the user to wipe all recording tapes and start from fresh
    @IBAction func resetButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.opaqueSeparator
        do {
            try fxAudioPlayer.synthOneRecorder.reset()
            try fxAudioPlayer.synthTwoRecorder.reset()
            try fxAudioPlayer.synthThreeRecorder.reset()
            try fxAudioPlayer.synthFourRecorder.reset()
            try fxAudioPlayer.drumsOneRecorder.reset()
            try fxAudioPlayer.drumsTwoRecorder.reset()
            try fxAudioPlayer.drumsThreeRecorder.reset()
            try fxAudioPlayer.drumsFourRecorder.reset()
            try fxAudioPlayer.micOneRecorder.reset()
            try fxAudioPlayer.micTwoRecorder.reset()
            try fxAudioPlayer.micThreeRecorder.reset()
            try fxAudioPlayer.micFourRecorder.reset()
        } catch {
            AKLog("Couldn't reset.")
        }
    }
    // Restore reset button's colour
    @IBAction func resetButtonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemTeal
    }
    // Allow the user to delete the last recording they made on each instrument
    @IBAction func lastRecordingsDeleteReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.systemOrange
    }
    
    // Allow the user to delete the last recording they made on the drums
    @IBAction func drumsResetButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.opaqueSeparator
        // Reset from the fourth recording backwards, so that a first (good) recording is not lost
        if fxAudioPlayer.drumsFourRecorder.recordedDuration > 0 {
           try! fxAudioPlayer.drumsFourRecorder.reset()
        } else {
            if fxAudioPlayer.drumsThreeRecorder.recordedDuration > 0 {
                try! fxAudioPlayer.drumsThreeRecorder.reset()
            } else {
                if fxAudioPlayer.drumsTwoRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.drumsTwoRecorder.reset()
                } else {
                    if fxAudioPlayer.drumsOneRecorder.recordedDuration >  0 {
                        try! fxAudioPlayer.drumsOneRecorder.reset()
                    }
                }
            }
        }
        
    }
    // Allow the user to delete the last recording they made on the synthesiser
    @IBAction func synthResetButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.opaqueSeparator
        // Reset from the fourth recording backwards, so that a first (good) recording is not lost
        if fxAudioPlayer.synthFourRecorder.recordedDuration > 0 {
           try! fxAudioPlayer.synthFourRecorder.reset()
        } else {
            if fxAudioPlayer.synthThreeRecorder.recordedDuration > 0 {
                try! fxAudioPlayer.synthThreeRecorder.reset()
            } else {
                if fxAudioPlayer.synthTwoRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.synthTwoRecorder.reset()
                } else {
                    if fxAudioPlayer.synthOneRecorder.recordedDuration >  0 {
                        try! fxAudioPlayer.synthOneRecorder.reset()
                    }
                }
            }
        }
    }
    // Allow the user to delete the last recording they made on the microphone
    @IBAction func micResetButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.opaqueSeparator
        // Reset from the fourth recording backwards, so that a first (good) recording is not lost
        if fxAudioPlayer.micFourRecorder.recordedDuration > 0 {
           try! fxAudioPlayer.micFourRecorder.reset()
        } else {
            if fxAudioPlayer.micThreeRecorder.recordedDuration > 0 {
                try! fxAudioPlayer.micThreeRecorder.reset()
            } else {
                if fxAudioPlayer.micTwoRecorder.recordedDuration > 0 {
                    try! fxAudioPlayer.micTwoRecorder.reset()
                } else {
                    if fxAudioPlayer.micOneRecorder.recordedDuration >  0 {
                        try! fxAudioPlayer.micOneRecorder.reset()
                    }
                }
            }
        }
    }
    
    
    


    
}

// MARK:- DRUM MACHINE FX VIEW CONTROLLER -

private var drumReverbStep: Int = 0
// Declare variables for each FX toggle so that it may keep its value between view segues
var drumReverbToggle = false
var drumDelayToggle = false
var drumHiPassToggle = false
var drumLoPassToggle = false
var drumDistortionToggle = false
var drumChorusToggle = false
var drumPhaserToggle = false
var drumFlangerToggle = false


class DrumMachineFXViewController: UIViewController {
    
    // Reverb outlets
    // Dry-Wet Mix
    @IBOutlet var reverbMixSlider: UISlider!
    @IBOutlet var reverbMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var reverbSwitch: UISwitch!
    @IBOutlet var reverbPresetStepper: UIStepper!
    @IBOutlet var reverbPresetLabel: UILabel!
    
    // Delay outlets
    // Dry-Wet Mix
    @IBOutlet var delayMixSlider: UISlider!
    @IBOutlet var delayMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var delaySwitch: UISwitch!
    // Delay Time
    @IBOutlet var delayTimeSlider: UISlider!
    @IBOutlet var delayTimeLabel: UILabel!
    // Feedback
    @IBOutlet var delayFeedbackSlider: UISlider!
    @IBOutlet var delayFeedbackLabel: UILabel!
    
    // High Pass Filter Outlets
    @IBOutlet var hiPassSwitch: UISwitch!
    @IBOutlet var hiPassFrequencySlider: UISlider!
    @IBOutlet var hiPassValueLabel: UILabel!
    @IBOutlet var hiPassQSlider: UISlider!
    @IBOutlet var hiPassQLabel: UILabel!
    @IBOutlet var hiPassMixSlider: UISlider!
    @IBOutlet var hiPassMixLabel: UILabel!
    
    // Low Pass Filter Outlets
    @IBOutlet var loPassSwitch: UISwitch!
    @IBOutlet var loPassFrequencySlider: UISlider!
    @IBOutlet var loPassValueLabel: UILabel!
    @IBOutlet var loPassQSlider: UISlider!
    @IBOutlet var loPassQLabel: UILabel!
    @IBOutlet var loPassMixSlider: UISlider!
    @IBOutlet var loPassMixLabel: UILabel!
    
    // Distortion Outlets
    @IBOutlet var distortionSwitch: UISwitch!
    @IBOutlet var preGainSlider: UISlider!
    @IBOutlet var preGainLabel: UILabel!
    @IBOutlet var postGainSlider: UISlider!
    @IBOutlet var postGainLabel: UILabel!
    @IBOutlet var positiveShapeSlider: UISlider!
    @IBOutlet var positiveShapeLabel: UILabel!
    
    // Panning Outlets
    @IBOutlet var xPanSlider: UISlider!
    @IBOutlet var xPanLabel: UILabel!
    @IBOutlet var yPanSlider: UISlider!
    @IBOutlet var yPanLabel: UILabel!
    @IBOutlet var zPanSlider: UISlider!
    @IBOutlet var zPanLabel: UILabel!
    
    // Chorus Outlets
    @IBOutlet var chorusSwitch: UISwitch!
    @IBOutlet var chorusMixSlider: UISlider!
    @IBOutlet var chorusMixLabel: UILabel!
    @IBOutlet var chorusDepthSlider: UISlider!
    @IBOutlet var chorusDepthLabel: UILabel!
    @IBOutlet var chorusFeedbackSlider: UISlider!
    @IBOutlet var chorusFeedbackLabel: UILabel!
    @IBOutlet var chorusFrequencySlider: UISlider!
    @IBOutlet var chorusFrequencyLabel: UILabel!
    
    // Phaser Outlets
    @IBOutlet var phaserSwitch: UISwitch!
    @IBOutlet var phaserDepthSlider: UISlider!
    @IBOutlet var phaserDepthLabel: UILabel!
    @IBOutlet var phaserFeedbackSlider: UISlider!
    @IBOutlet var phaserFeedbackLabel: UILabel!
    @IBOutlet var phaserBPMSlider: UISlider!
    @IBOutlet var phaserBPMLabel: UILabel!
    
    // Flanger Outlets
    @IBOutlet var flangerSwitch: UISwitch!
    @IBOutlet var flangerMixSlider: UISlider!
    @IBOutlet var flangerMixLabel: UILabel!
    @IBOutlet var flangerDepthSlider: UISlider!
    @IBOutlet var flangerDepthLabel: UILabel!
    @IBOutlet var flangerFeedbackSlider: UISlider!
    @IBOutlet var flangerFeedbackLabel: UILabel!
    @IBOutlet var flangerFrequencySlider: UISlider!
    @IBOutlet var flangerFrequencyLabel: UILabel!
  
    // Declare an array of strings, which hold the names of the reverb presets we will be using
    private let reverbRooms = ["Small Room", "Medium Room", "Large Room", "Medium Hall", "Large Hall", "Medium Chamber", "Cathedral", "Plate"]
    
    /* Function that gets called each time the Keyboard FX Processor View loads */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if firstTime == true {
            firstTime = false
            fxAudioPlayer = FXAudioPlayer()
        }
        /* re-initialise each slider/label so their data is kept between segues */
        // Set switch values to their boolean variables from earlier so that the keep their values
        reverbSwitch.isOn = drumReverbToggle
        delaySwitch.isOn = drumDelayToggle
        distortionSwitch.isOn = drumDistortionToggle
        hiPassSwitch.isOn = drumHiPassToggle
        loPassSwitch.isOn = drumLoPassToggle
        chorusSwitch.isOn = drumChorusToggle
        flangerSwitch.isOn = drumFlangerToggle
        phaserSwitch.isOn = drumPhaserToggle
        // Reverb data to be kept between segues
        reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumReverb.dryWetMix)
        reverbMixSlider.value = Float(fxAudioPlayer.drumReverb.dryWetMix.value())
        reverbPresetStepper.value = Double(drumReverbStep)
        reverbPresetLabel.text = String(reverbRooms[drumReverbStep])
        // Delay data to be kept between segues
        delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.time)
        delayTimeSlider.value = Float(fxAudioPlayer.drumDelay.time)
        delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.feedback)
        delayFeedbackSlider.value = Float(fxAudioPlayer.drumDelay.feedback)
        delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.dryWetMix)
        delayMixSlider.value = Float(fxAudioPlayer.drumDelay.dryWetMix)
        // High pass filter data to be kept between segues
        hiPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.drumHiPass.cutoffFrequency)
        hiPassFrequencySlider.value = Float(fxAudioPlayer.drumHiPass.cutoffFrequency)
        hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumHiPass.dryWetMix)
        hiPassMixSlider.value = Float(fxAudioPlayer.drumHiPass.dryWetMix)
        hiPassQSlider.value = Float(fxAudioPlayer.drumHiPass.resonance)
        hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.drumHiPass.resonance)
        // Low pass filter data to be kept between segues
        loPassQSlider.value = Float(fxAudioPlayer.drumLoPass.resonance)
        loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.drumLoPass.resonance)
        loPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.drumLoPass.cutoffFrequency)
        loPassFrequencySlider.value = Float(fxAudioPlayer.drumLoPass.cutoffFrequency)
        loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumLoPass.dryWetMix)
        loPassMixSlider.value = Float(fxAudioPlayer.drumLoPass.dryWetMix)
        // Distortion data to be kept between segues
        preGainSlider.value = Float(fxAudioPlayer.drumDistortion.pregain)
        preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.pregain)
        postGainSlider.value = Float(fxAudioPlayer.drumDistortion.postgain)
        postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.postgain)
        positiveShapeSlider.value = Float(fxAudioPlayer.drumDistortion.positiveShapeParameter)
        positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.positiveShapeParameter)
        // Chorus data to be kept between segues
        chorusMixSlider.value = Float(fxAudioPlayer.drumChorus.dryWetMix)
        chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.dryWetMix)
        chorusDepthSlider.value = Float(fxAudioPlayer.drumChorus.depth)
        chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.depth)
        chorusFeedbackSlider.value = Float(fxAudioPlayer.drumChorus.feedback)
        chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.feedback)
        chorusFrequencySlider.value = Float(fxAudioPlayer.drumChorus.frequency)
        chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.frequency)
        // Phaser data to be kept between segues
        phaserDepthSlider.value = Float(fxAudioPlayer.drumPhaser.depth)
        phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.depth)
        phaserFeedbackSlider.value = Float(fxAudioPlayer.drumPhaser.feedback)
        phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.feedback)
        phaserBPMSlider.value = Float(fxAudioPlayer.drumPhaser.lfoBPM)
        phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.lfoBPM)
        // Flanger data to be kept between segues
        flangerMixSlider.value = Float(fxAudioPlayer.drumFlanger.dryWetMix)
        flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.dryWetMix)
        flangerDepthSlider.value = Float(fxAudioPlayer.drumFlanger.depth)
        flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.depth)
        flangerFeedbackSlider.value = Float(fxAudioPlayer.drumFlanger.feedback)
        flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.feedback)
        flangerFrequencySlider.value = Float(fxAudioPlayer.drumFlanger.frequency)
        flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.frequency)
        // 3D Panning Data to be kept between segues
        xPanSlider.value = Float(fxAudioPlayer.drumPanner.x)
        yPanSlider.value = Float(fxAudioPlayer.drumPanner.y)
        zPanSlider.value = Float(fxAudioPlayer.drumPanner.z)
    }

    // A method to turn the reverb on or off
    @IBAction func toggleReverb(_ sender: Any) {
        if reverbSwitch.isOn {
            // If switch is on, then start the reverb processor
            fxAudioPlayer.drumReverb.start()
            fxAudioPlayer.setDrumsReverbMixValue(reverbMixSlider.value)
            // Let future segue view controllers know the switch's value
            drumReverbToggle = true
        } else {
            // Keep track of the value of the slider whilst reverb is off and equate amount of reverb to slider value.
            fxAudioPlayer.drumReverb.stop()
            fxAudioPlayer.setDrumsReverbMixValue(Float(fxAudioPlayer.drumReverb.dryWetMix))
            // Let future segue view controllers know the switch's value
            drumReverbToggle = false
            
        }
    }
    // A method to set the wet/dry value of the reverb
    @IBAction func setReverbMixValue(_ sender: UISlider) { // Called when slider is moved
        
        // If the reverb switch is on, then allow the reverb value to be changed
        if reverbSwitch.isOn == true {
            reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumReverb.dryWetMix)
            fxAudioPlayer.setDrumsReverbMixValue(reverbMixSlider.value)
            
        } else {
            // If it isn't on, then only change the label - not the reverb property itself
            reverbMixLabel.text = String(format: "%0.2f", reverbMixSlider.value)
        }
    }
    // A method to choose each reverb preset.
    @IBAction func setReverbPreset(_ sender: UIStepper) {
        // User flicks through a stepper, each step holds a value of a different preset
        switch (sender.value) {
        case 0: fxAudioPlayer.drumReverb.loadFactoryPreset(.smallRoom)
            reverbPresetLabel.text = String(reverbRooms[0])
        case 1: fxAudioPlayer.drumReverb.loadFactoryPreset(.mediumRoom)
            reverbPresetLabel.text = String(reverbRooms[1])
        case 2: fxAudioPlayer.drumReverb.loadFactoryPreset(.largeRoom)
            reverbPresetLabel.text = String(reverbRooms[2])
        case 3: fxAudioPlayer.drumReverb.loadFactoryPreset(.mediumHall)
            reverbPresetLabel.text = String(reverbRooms[3])
        case 4: fxAudioPlayer.drumReverb.loadFactoryPreset(.largeHall)
            reverbPresetLabel.text = String(reverbRooms[4])
        case 5: fxAudioPlayer.drumReverb.loadFactoryPreset(.mediumChamber)
            reverbPresetLabel.text = String(reverbRooms[5])
        case 6: fxAudioPlayer.drumReverb.loadFactoryPreset(.cathedral)
            reverbPresetLabel.text = String(reverbRooms[6])
        case 7: fxAudioPlayer.drumReverb.loadFactoryPreset(.plate)
            reverbPresetLabel.text = String(reverbRooms[7])
        default: fxAudioPlayer.drumReverb.loadFactoryPreset(.smallRoom)
        }
        drumReverbStep = Int(sender.value)
    }
    // A method to turn the delay on or off
    @IBAction func toggleDelay(_ sender: UISwitch) {
        
        if delaySwitch.isOn {
            // Switch delay on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.drumDelay.start()
            fxAudioPlayer.setDrumsDelayTimeValue(delayTimeSlider.value)
            fxAudioPlayer.setDrumsDelayFeedbackValue(delayFeedbackSlider.value)
            fxAudioPlayer.setDrumsDelayMixValue(delayMixSlider.value)
            drumDelayToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setDrumsDelayFeedbackValue(Float(fxAudioPlayer.drumDelay.feedback))
            fxAudioPlayer.setDrumsDelayTimeValue(Float(fxAudioPlayer.drumDelay.time))
            fxAudioPlayer.setDrumsDelayMixValue(Float(fxAudioPlayer.drumDelay.dryWetMix))
            fxAudioPlayer.drumDelay.stop()
            drumDelayToggle = false
        }
    }
    // A method to set the wet/dry value of the delay
    @IBAction func setDelayMixValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setDrumsDelayMixValue(delayMixSlider.value)
            delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.dryWetMix)
        } else {
            delayMixLabel.text = String(format: "%0.2f", delayMixSlider.value)
        }
    }
    // A method to set the time value of the delay
    @IBAction func setDelayTimeValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setDrumsDelayTimeValue(delayTimeSlider.value)
            delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.time)
        } else {
            delayTimeLabel.text = String(format: "%0.2f", delayTimeSlider.value)
        }
    }
    // A method to set the feedback value of the delay
    @IBAction func setDelayFeedbackValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setDrumsDelayFeedbackValue(delayFeedbackSlider.value)
            delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDelay.feedback)
        } else {
            delayFeedbackLabel.text = String(format: "%0.2f", delayFeedbackSlider.value)
        }
    }
    // A method to turn the HiPass filter on or off
    @IBAction func toggleHiPass(_ sender: UISwitch) {
        
           if hiPassSwitch.isOn {
               // Switch high-pass filter on and make sure that it takes the new value of the slider if changed
               fxAudioPlayer.drumHiPass.start()
               fxAudioPlayer.setDrumsHiPassMixValue(hiPassMixSlider.value)
               fxAudioPlayer.setDrumsHiPassQValue(hiPassQSlider.value)
               fxAudioPlayer.setDrumsHiPassFrequency(hiPassFrequencySlider.value)
               drumHiPassToggle = true
           } else {
               // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.

               fxAudioPlayer.setDrumsHiPassMixValue(Float(fxAudioPlayer.drumHiPass.dryWetMix))
               fxAudioPlayer.setDrumsHiPassQValue(Float(fxAudioPlayer.drumHiPass.resonance))
               fxAudioPlayer.setDrumsHiPassFrequency(Float(fxAudioPlayer.drumHiPass.cutoffFrequency))
               fxAudioPlayer.drumHiPass.stop()
               drumHiPassToggle = false
           }
        }
        // A method to set the cut off frequency for the high pass filter
    @IBAction func setHiPassFrequencyValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setDrumsHiPassFrequency(hiPassFrequencySlider.value)
            hiPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.drumHiPass.cutoffFrequency)
        } else {
            hiPassValueLabel.text = String(format: "%0.0f", hiPassFrequencySlider.value)
        }
    }
    // A method to set the Q value for the high pass filter
    @IBAction func setHiPassQValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setDrumsHiPassQValue(hiPassQSlider.value)
            hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.drumHiPass.resonance)
        } else {
            hiPassQLabel.text = String(format: "%0.2f", hiPassQSlider.value)
        }
    }
    // A method to set the wet/dry mix for the high pass filter
    @IBAction func setHiPassMixValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setDrumsHiPassMixValue(hiPassMixSlider.value)
            hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumHiPass.dryWetMix)
        } else {
            hiPassMixLabel.text = String(format: "%0.2f", hiPassMixSlider.value)
        }
    }
    // A method to turn the Low pass filter on or off
    @IBAction func toggleLoPass(_ sender: UISwitch) {
        
        if loPassSwitch.isOn {
           // Switch low-pass filter on and make sure that it takes the new value of the slider if changed
           fxAudioPlayer.drumLoPass.start()
           fxAudioPlayer.setDrumsLoPassMixValue(loPassMixSlider.value)
           fxAudioPlayer.setDrumsLoPassQValue(loPassQSlider.value)
           fxAudioPlayer.setDrumsLoPassFrequency(loPassFrequencySlider.value)
           drumLoPassToggle = true
       } else {
           // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.

           fxAudioPlayer.setDrumsLoPassMixValue(Float(fxAudioPlayer.drumLoPass.dryWetMix))
           fxAudioPlayer.setDrumsLoPassQValue(Float(fxAudioPlayer.drumLoPass.resonance))
           fxAudioPlayer.setDrumsLoPassFrequency(Float(fxAudioPlayer.drumLoPass.cutoffFrequency))
           fxAudioPlayer.drumHiPass.stop()
           drumLoPassToggle = false
       }
    }
    // A method to set the frequency of the low pass filter
    @IBAction func setLoPassFrequencyValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setDrumsLoPassFrequency(loPassFrequencySlider.value)
            loPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.drumLoPass.cutoffFrequency)
        } else {
            loPassValueLabel.text = String(format: "%0.0f", loPassFrequencySlider.value)
        }
        
    }
    // A method to set the Q value of the low pass filter
    @IBAction func setLoPassQValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setDrumsLoPassQValue(loPassQSlider.value)
            loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.drumLoPass.resonance)
        } else {
            loPassQLabel.text = String(format: "%0.2f", loPassQSlider.value)
        }
    }
    // A method to set the wet/dry mix of the low pass filter
    @IBAction func setLoPassMixValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setDrumsLoPassMixValue(loPassMixSlider.value)
            loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumLoPass.dryWetMix)
        } else {
            loPassMixLabel.text = String(format: "%0.2f", loPassMixSlider.value)
        }
    }
    // A method to turn the distortion on/off
    @IBAction func toggleDistortion(_ sender: UISwitch) {
        
        if distortionSwitch.isOn {
            // Switch distortion on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.drumDistortion.start()
            fxAudioPlayer.setDrumsDistortionPreGainValue(preGainSlider.value)
            fxAudioPlayer.setDrumsDistortionPostGainValue(postGainSlider.value)
            fxAudioPlayer.setDrumsDistortionPositiveShape(positiveShapeSlider.value)
            drumDistortionToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setDrumsDistortionPreGainValue(Float(fxAudioPlayer.drumDistortion.pregain))
            fxAudioPlayer.setDrumsDistortionPostGainValue(Float(fxAudioPlayer.drumDistortion.postgain))
            fxAudioPlayer.setDrumsDistortionPositiveShape(Float(fxAudioPlayer.drumDistortion.positiveShapeParameter))
            fxAudioPlayer.drumDistortion.stop()
            // Update overall data
            drumDistortionToggle = false
        }
    }
    // A method to set the pre gain value for the distortion
    @IBAction func setPreGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setDrumsDistortionPreGainValue(preGainSlider.value)
            preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.pregain)
        } else {
            preGainLabel.text = String(format: "%0.2f", preGainSlider.value)
        }
    }
    // A method to set the post gain value for the distortion
    @IBAction func setPostGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setDrumsDistortionPostGainValue(postGainSlider.value)
            postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.postgain)
        } else {
            postGainLabel.text = String(format: "%0.2f", postGainSlider.value)
        }
    }
    // A method to set the shape of the distortion
    @IBAction func setPositiveShapeValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setDrumsDistortionPositiveShape(positiveShapeSlider.value)
            positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.drumDistortion.positiveShapeParameter)
        } else {
            positiveShapeLabel.text = String(format: "%0.2f", positiveShapeSlider.value)
        }
        
    }
    // A method to set the X-axis panning of the drum machines
    @IBAction func setXPanValue(_ sender: UISlider) {
        fxAudioPlayer.setDrumsXPan(xPanSlider.value)
        xPanLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPanner.x)
    }
    // A method to set the Y-axis panning of the drum machines
    @IBAction func setYPanValue(_ sender: UISlider) {
        fxAudioPlayer.setDrumsYPan(yPanSlider.value)
        yPanLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPanner.y)
    }
    // A method to set the Z-axis panning of the drum machines
    @IBAction func setZPanValue(_ sender: UISlider) {
        fxAudioPlayer.setDrumsZPan(zPanSlider.value)
        zPanLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPanner.z)
    }
    // A method to toggle the Chorus processor on or off
    @IBAction func toggleChorus(_ sender: UISwitch) {
        
        if chorusSwitch.isOn {
            // Switch chorus on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.drumChorus.start()
            fxAudioPlayer.setDrumsChorusMix(chorusMixSlider.value)
            fxAudioPlayer.setDrumsChorusDepth(chorusDepthSlider.value)
            fxAudioPlayer.setDrumsChorusFeedback(chorusFeedbackSlider.value)
            fxAudioPlayer.setDrumsChorusFrequency(chorusFrequencySlider.value)
            drumChorusToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setDrumsChorusMix(Float(fxAudioPlayer.drumChorus.dryWetMix))
            fxAudioPlayer.setDrumsChorusDepth(Float(fxAudioPlayer.drumChorus.depth))
            fxAudioPlayer.setDrumsChorusFeedback(Float(fxAudioPlayer.drumChorus.feedback))
            fxAudioPlayer.setDrumsChorusFrequency(Float(fxAudioPlayer.drumChorus.frequency))
            fxAudioPlayer.drumChorus.stop()
            drumChorusToggle = false
        }
    }
    // A method to set the value of the dry/wet mix for the chorus processor
    @IBAction func setChorusMixValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setDrumsChorusMix(chorusMixSlider.value)
                chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.dryWetMix)
            } else {
                chorusMixLabel.text = String(format: "%0.2f", chorusMixSlider.value)
            }
    }
    // A method to set the value of the depth for the chorus processor
    @IBAction func setChorusDepthValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setDrumsChorusDepth(chorusDepthSlider.value)
                chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.depth)
            } else {
                chorusDepthLabel.text = String(format: "%0.2f", chorusDepthSlider.value)
            }
    }
        // A method to set the value of the feedback for the chorus processor
    @IBAction func setChorusFeedbackValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setDrumsChorusFeedback(chorusFeedbackSlider.value)
                chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.feedback)
            } else {
                chorusFeedbackLabel.text = String(format: "%0.2f", chorusFeedbackSlider.value)
            }
    }
    // A method to set the value of the frequency for the chorus processor
    @IBAction func setChorusFrequency(_ sender: UISlider) {
        if chorusSwitch.isOn {
               fxAudioPlayer.setDrumsChorusFrequency(chorusFrequencySlider.value)
               chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.drumChorus.frequency)
           } else {
               chorusFrequencyLabel.text = String(format: "%0.2f", chorusFrequencySlider.value)
           }
    }
    // A method to toggle the phaser processor on or off
    @IBAction func togglePhaser(_ sender: UISwitch) {
        
        if phaserSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if change
            fxAudioPlayer.drumPhaser.start()
            fxAudioPlayer.setDrumsPhaserBPM(phaserBPMSlider.value)
            fxAudioPlayer.setDrumsPhaserDepth(phaserDepthSlider.value)
            fxAudioPlayer.setDrumsPhaserFeedback(phaserFeedbackSlider.value)
            drumPhaserToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setDrumsPhaserBPM(Float(fxAudioPlayer.drumPhaser.lfoBPM))
            fxAudioPlayer.setDrumsPhaserDepth(Float(fxAudioPlayer.drumPhaser.depth))
            fxAudioPlayer.setDrumsPhaserFeedback(Float(fxAudioPlayer.drumPhaser.feedback))
            fxAudioPlayer.drumPhaser.stop()
            drumPhaserToggle = false
        }
    }
    // A method to set the phaser depth value
    @IBAction func setPhaserDepth(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setDrumsPhaserDepth(phaserDepthSlider.value)
            phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.depth)
        } else {
            phaserDepthLabel.text = String(format: "%0.2f", phaserDepthSlider.value)
        }
    }
    // A method to set the phaser feedback value
    @IBAction func setPhaserFeedback(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setDrumsPhaserFeedback(phaserFeedbackSlider.value)
            phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.feedback)
        } else {
            phaserFeedbackLabel.text = String(format: "%0.2f", phaserFeedbackSlider.value)
        }
    }
    // A method to set the BPM value
    @IBAction func setPhaserBPM(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setDrumsPhaserBPM(phaserBPMSlider.value)
            phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.drumPhaser.lfoBPM)
        } else {
            phaserBPMLabel.text = String(format: "%0.2f", phaserBPMSlider.value)
        }
        
    }
    // A method to toggle the flanger processor on or off
    @IBAction func toggleFlanger(_ sender: UISwitch) {
        
        if flangerSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.drumFlanger.start()
            fxAudioPlayer.setDrumsFlangerMix(flangerMixSlider.value)
            fxAudioPlayer.setDrumsFlangerDepth(flangerDepthSlider.value)
            fxAudioPlayer.setDrumsFlangerFeedback(flangerFeedbackSlider.value)
            fxAudioPlayer.setDrumsFlangerFrequency(flangerFrequencySlider.value)
            drumFlangerToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setDrumsFlangerMix(Float(fxAudioPlayer.drumFlanger.dryWetMix))
            fxAudioPlayer.setDrumsFlangerDepth(Float(fxAudioPlayer.drumFlanger.depth))
            fxAudioPlayer.setDrumsFlangerFeedback(Float(fxAudioPlayer.drumFlanger.feedback))
            fxAudioPlayer.setDrumsFlangerFrequency(Float(fxAudioPlayer.drumFlanger.frequency))
            fxAudioPlayer.drumFlanger.stop()
            drumFlangerToggle = false
        }
    }
    // A method to set the dry/wet mix value of the flanger
    @IBAction func setFlangerMixValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setDrumsFlangerMix(flangerMixSlider.value)
            flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.dryWetMix)
        } else {
            flangerMixLabel.text = String(format: "%0.2f", flangerMixSlider.value)
        }
        
    }
    // A method to set the depth value of the flanger
    @IBAction func setFlangerDepthValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setDrumsFlangerDepth(flangerDepthSlider.value)
            flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.depth)
        } else {
            flangerDepthLabel.text = String(format: "%0.2f", flangerDepthSlider.value)
        }
    }
    // A method to set the feedback value of the flanger
    @IBAction func setFlangerFeedbackValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setDrumsFlangerFeedback(flangerFeedbackSlider.value)
            flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.feedback)
        } else {
            flangerFeedbackLabel.text = String(format: "%0.2f", flangerFeedbackSlider.value)
        }
    }
    
    // A method to set the frequency value of the flanger
    @IBAction func setFlangerFrequency(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setDrumsFlangerFrequency(flangerFrequencySlider.value)
            flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.drumFlanger.frequency)
        } else {
            flangerFrequencyLabel.text = String(format: "%0.2f", flangerFrequencySlider.value)
        }
    }

}

// MARK:- KEYBOARD AUDIO VIEW CONTROLLER -

// MARK:- FOR COMMENTS, REFER TO DRUM MACHINE VIEW CONTROLLER, AS THEY ARE IDENTICAL

private var synthReverbStep: Int = 0
var synthReverbToggle = false
var synthDelayToggle = false
var synthHiPassToggle = false
var synthLoPassToggle = false
var synthDistortionToggle = false
var synthChorusToggle = false
var synthPhaserToggle = false
var synthFlangerToggle = false


class KeyboardFXViewController: UIViewController {
    
    // Reverb outlets
    // Dry-Wet Mix
    @IBOutlet var reverbMixSlider: UISlider!
    @IBOutlet var reverbMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var reverbSwitch: UISwitch!
    @IBOutlet var reverbPresetStepper: UIStepper!
    @IBOutlet var reverbPresetLabel: UILabel!
    
    // Delay outlets
    // Dry-Wet Mix
    @IBOutlet var delayMixSlider: UISlider!
    @IBOutlet var delayMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var delaySwitch: UISwitch!
    // Delay Time
    @IBOutlet var delayTimeSlider: UISlider!
    @IBOutlet var delayTimeLabel: UILabel!
    // Feedback
    @IBOutlet var delayFeedbackSlider: UISlider!
    @IBOutlet var delayFeedbackLabel: UILabel!
    
    // High Pass Filter Outlets
    @IBOutlet var hiPassSwitch: UISwitch!
    @IBOutlet var hiPassFrequencySlider: UISlider!
    @IBOutlet var hiPassValueLabel: UILabel!
    @IBOutlet var hiPassQSlider: UISlider!
    @IBOutlet var hiPassQLabel: UILabel!
    @IBOutlet var hiPassMixSlider: UISlider!
    @IBOutlet var hiPassMixLabel: UILabel!
    
    // Low Pass Filter Outlets
    @IBOutlet var loPassSwitch: UISwitch!
    @IBOutlet var loPassFrequencySlider: UISlider!
    @IBOutlet var loPassValueLabel: UILabel!
    @IBOutlet var loPassQSlider: UISlider!
    @IBOutlet var loPassQLabel: UILabel!
    @IBOutlet var loPassMixSlider: UISlider!
    @IBOutlet var loPassMixLabel: UILabel!
    
    // Distortion Outlets
    @IBOutlet var distortionSwitch: UISwitch!
    @IBOutlet var preGainSlider: UISlider!
    @IBOutlet var preGainLabel: UILabel!
    @IBOutlet var postGainSlider: UISlider!
    @IBOutlet var postGainLabel: UILabel!
    @IBOutlet var positiveShapeSlider: UISlider!
    @IBOutlet var positiveShapeLabel: UILabel!
    
    // Panning Outlets
    @IBOutlet var xPanSlider: UISlider!
    @IBOutlet var xPanLabel: UILabel!
    @IBOutlet var yPanSlider: UISlider!
    @IBOutlet var yPanLabel: UILabel!
    @IBOutlet var zPanSlider: UISlider!
    @IBOutlet var zPanLabel: UILabel!
    
    // Chorus Outlets
    @IBOutlet var chorusSwitch: UISwitch!
    @IBOutlet var chorusMixSlider: UISlider!
    @IBOutlet var chorusMixLabel: UILabel!
    @IBOutlet var chorusDepthSlider: UISlider!
    @IBOutlet var chorusDepthLabel: UILabel!
    @IBOutlet var chorusFeedbackSlider: UISlider!
    @IBOutlet var chorusFeedbackLabel: UILabel!
    @IBOutlet var chorusFrequencySlider: UISlider!
    @IBOutlet var chorusFrequencyLabel: UILabel!
    
    // Phaser Outlets
    @IBOutlet var phaserSwitch: UISwitch!
    @IBOutlet var phaserDepthSlider: UISlider!
    @IBOutlet var phaserDepthLabel: UILabel!
    @IBOutlet var phaserFeedbackSlider: UISlider!
    @IBOutlet var phaserFeedbackLabel: UILabel!
    @IBOutlet var phaserBPMSlider: UISlider!
    @IBOutlet var phaserBPMLabel: UILabel!
    
    // Flanger Outlets
    @IBOutlet var flangerSwitch: UISwitch!
    @IBOutlet var flangerMixSlider: UISlider!
    @IBOutlet var flangerMixLabel: UILabel!
    @IBOutlet var flangerDepthSlider: UISlider!
    @IBOutlet var flangerDepthLabel: UILabel!
    @IBOutlet var flangerFeedbackSlider: UISlider!
    @IBOutlet var flangerFeedbackLabel: UILabel!
    @IBOutlet var flangerFrequencySlider: UISlider!
    @IBOutlet var flangerFrequencyLabel: UILabel!
    
    private let reverbRooms = ["Small Room", "Medium Room", "Large Room", "Medium Hall", "Large Hall", "Medium Chamber", "Cathedral", "Plate"]
    
    /* Function that gets called each time the Keyboard FX Processor View loads */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if firstTime == true {
            firstTime = false
            fxAudioPlayer = FXAudioPlayer()
        }
        /* re-initialise each slider/label so their data is kept between segues */
        reverbSwitch.isOn = synthReverbToggle
        delaySwitch.isOn = synthDelayToggle
        distortionSwitch.isOn = synthDistortionToggle
        hiPassSwitch.isOn = synthHiPassToggle
        loPassSwitch.isOn = synthLoPassToggle
        chorusSwitch.isOn = synthChorusToggle
        flangerSwitch.isOn = synthFlangerToggle
        phaserSwitch.isOn = synthPhaserToggle
        
        reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthReverb.dryWetMix)
        reverbMixSlider.value = Float(fxAudioPlayer.synthReverb.dryWetMix.value())
        reverbPresetStepper.value = Double(synthReverbStep)
        reverbPresetLabel.text = String(reverbRooms[synthReverbStep])
        
        delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.time)
        delayTimeSlider.value = Float(fxAudioPlayer.synthDelay.time)
        delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.feedback)
        delayFeedbackSlider.value = Float(fxAudioPlayer.synthDelay.feedback)
        delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.dryWetMix)
        delayMixSlider.value = Float(fxAudioPlayer.synthDelay.dryWetMix)
        
        hiPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.synthHiPass.cutoffFrequency)
        hiPassFrequencySlider.value = Float(fxAudioPlayer.synthHiPass.cutoffFrequency)
        hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthHiPass.dryWetMix)
        hiPassMixSlider.value = Float(fxAudioPlayer.synthHiPass.dryWetMix)
        hiPassQSlider.value = Float(fxAudioPlayer.synthHiPass.resonance)
        hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.synthHiPass.resonance)
        
        loPassQSlider.value = Float(fxAudioPlayer.synthLoPass.resonance)
        loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.synthLoPass.resonance)
        loPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.synthLoPass.cutoffFrequency)
        loPassFrequencySlider.value = Float(fxAudioPlayer.synthLoPass.cutoffFrequency)
        loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthLoPass.dryWetMix)
        loPassMixSlider.value = Float(fxAudioPlayer.synthLoPass.dryWetMix)
        
        preGainSlider.value = Float(fxAudioPlayer.synthDistortion.pregain)
        preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.pregain)
        postGainSlider.value = Float(fxAudioPlayer.synthDistortion.postgain)
        postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.postgain)
        positiveShapeSlider.value = Float(fxAudioPlayer.synthDistortion.positiveShapeParameter)
        positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.positiveShapeParameter)
        
        chorusMixSlider.value = Float(fxAudioPlayer.synthChorus.dryWetMix)
        chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.dryWetMix)
        chorusDepthSlider.value = Float(fxAudioPlayer.synthChorus.depth)
        chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.depth)
        chorusFeedbackSlider.value = Float(fxAudioPlayer.synthChorus.feedback)
        chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.feedback)
        chorusFrequencySlider.value = Float(fxAudioPlayer.synthChorus.frequency)
        chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.frequency)
        
        phaserDepthSlider.value = Float(fxAudioPlayer.synthPhaser.depth)
        phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.depth)
        phaserFeedbackSlider.value = Float(fxAudioPlayer.synthPhaser.feedback)
        phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.feedback)
        phaserBPMSlider.value = Float(fxAudioPlayer.synthPhaser.lfoBPM)
        phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.lfoBPM)

        flangerMixSlider.value = Float(fxAudioPlayer.synthFlanger.dryWetMix)
        flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.dryWetMix)
        flangerDepthSlider.value = Float(fxAudioPlayer.synthFlanger.depth)
        flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.depth)
        flangerFeedbackSlider.value = Float(fxAudioPlayer.synthFlanger.feedback)
        flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.feedback)
        flangerFrequencySlider.value = Float(fxAudioPlayer.synthFlanger.frequency)
        flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.frequency)
        
        xPanSlider.value = Float(fxAudioPlayer.synthPanner.x)
        yPanSlider.value = Float(fxAudioPlayer.synthPanner.y)
        zPanSlider.value = Float(fxAudioPlayer.synthPanner.z)

        
    }

    
    @IBAction func toggleReverb(_ sender: Any) {
        if reverbSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.synthReverb.start()
            fxAudioPlayer.setSynthReverbMixValue(reverbMixSlider.value)
            synthReverbToggle = true
        } else {
            // Keep track of the value of the slider whilst reverb is off and equate amount of reverb to slider value.
            fxAudioPlayer.synthReverb.stop()
            fxAudioPlayer.setSynthReverbMixValue(Float(fxAudioPlayer.synthReverb.dryWetMix))
            
            synthReverbToggle = false
            
        }
    }
    
    @IBAction func setReverbMixValue(_ sender: UISlider) { // Called when slider is moved
        
        if reverbSwitch.isOn == true {
            reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthReverb.dryWetMix)
            fxAudioPlayer.setSynthReverbMixValue(reverbMixSlider.value)
            
        } else {
            reverbMixLabel.text = String(format: "%0.2f", reverbMixSlider.value)
        }
    }
    
    @IBAction func setReverbPreset(_ sender: UIStepper) {
        switch (sender.value) {
        case 0: fxAudioPlayer.synthReverb.loadFactoryPreset(.smallRoom)
            reverbPresetLabel.text = String(reverbRooms[0])
        case 1: fxAudioPlayer.synthReverb.loadFactoryPreset(.mediumRoom)
            reverbPresetLabel.text = String(reverbRooms[1])
        case 2: fxAudioPlayer.synthReverb.loadFactoryPreset(.largeRoom)
            reverbPresetLabel.text = String(reverbRooms[2])
        case 3: fxAudioPlayer.synthReverb.loadFactoryPreset(.mediumHall)
            reverbPresetLabel.text = String(reverbRooms[3])
        case 4: fxAudioPlayer.synthReverb.loadFactoryPreset(.largeHall)
            reverbPresetLabel.text = String(reverbRooms[4])
        case 5: fxAudioPlayer.synthReverb.loadFactoryPreset(.mediumChamber)
            reverbPresetLabel.text = String(reverbRooms[5])
        case 6: fxAudioPlayer.synthReverb.loadFactoryPreset(.cathedral)
            reverbPresetLabel.text = String(reverbRooms[6])
        case 7: fxAudioPlayer.synthReverb.loadFactoryPreset(.plate)
            reverbPresetLabel.text = String(reverbRooms[7])
        default: fxAudioPlayer.synthReverb.loadFactoryPreset(.smallRoom)
        }
        synthReverbStep = Int(sender.value)
    }

    @IBAction func toggleDelay(_ sender: UISwitch) {
        
        if delaySwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            // This chaining is super FKIN complicated. Take time to understand what's going on
            fxAudioPlayer.synthDelay.start()
            fxAudioPlayer.setSynthDelayTimeValue(delayTimeSlider.value)
            fxAudioPlayer.setSynthDelayFeedbackValue(delayFeedbackSlider.value)
            fxAudioPlayer.setSynthDelayMixValue(delayMixSlider.value)
            synthDelayToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setSynthDelayFeedbackValue(Float(fxAudioPlayer.synthDelay.feedback))
            fxAudioPlayer.setSynthDelayTimeValue(Float(fxAudioPlayer.synthDelay.time))
            fxAudioPlayer.setSynthDelayMixValue(Float(fxAudioPlayer.synthDelay.dryWetMix))
            fxAudioPlayer.synthDelay.stop()
            synthDelayToggle = false
        }
    }
    
    @IBAction func setDelayMixValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setSynthDelayMixValue(delayMixSlider.value)
            delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.dryWetMix)
        } else {
            delayMixLabel.text = String(format: "%0.2f", delayMixSlider.value)
        }
    }
    
    @IBAction func setDelayTimeValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setSynthDelayTimeValue(delayTimeSlider.value)
            delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.time)
        } else {
            delayTimeLabel.text = String(format: "%0.2f", delayTimeSlider.value)
        }
    }
    
    @IBAction func setDelayFrequencyValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setSynthDelayFeedbackValue(delayFeedbackSlider.value)
            delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDelay.feedback)
        } else {
            delayFeedbackLabel.text = String(format: "%0.2f", delayFeedbackSlider.value)
        }
    }
    
    @IBAction func toggleHiPass(_ sender: UISwitch) {
        
        if hiPassSwitch.isOn {
                   // Switch high-pass filter on and make sure that it takes the new value of the slider if changed
                   fxAudioPlayer.synthHiPass.start()
                   fxAudioPlayer.setSynthHiPassMixValue(hiPassMixSlider.value)
                   fxAudioPlayer.setSynthHiPassQValue(hiPassQSlider.value)
                   fxAudioPlayer.setSynthHiPassFrequency(hiPassFrequencySlider.value)
                   synthHiPassToggle = true
               } else {
                   // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
                   fxAudioPlayer.setSynthHiPassMixValue(Float(fxAudioPlayer.synthHiPass.dryWetMix))
                   fxAudioPlayer.setSynthHiPassQValue(Float(fxAudioPlayer.synthHiPass.resonance))
                   fxAudioPlayer.setSynthHiPassFrequency(Float(fxAudioPlayer.synthHiPass.cutoffFrequency))
                   fxAudioPlayer.synthHiPass.stop()
                   synthHiPassToggle = false
               }
        }
        
    @IBAction func setHiPassFrequencyValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setSynthHiPassFrequency(hiPassFrequencySlider.value)
            hiPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.synthHiPass.cutoffFrequency)
        } else {
            hiPassValueLabel.text = String(format: "%0.0f", hiPassFrequencySlider.value)
        }
    }
    
    @IBAction func setHiPassQValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setSynthHiPassQValue(hiPassQSlider.value)
            hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.synthHiPass.resonance)
        } else {
            hiPassQLabel.text = String(format: "%0.2f", hiPassQSlider.value)
        }
    }
    
    @IBAction func setHiPassMixValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setSynthHiPassMixValue(hiPassMixSlider.value)
            hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthHiPass.dryWetMix)
        } else {
            hiPassMixLabel.text = String(format: "%0.2f", hiPassMixSlider.value)
        }
    }
    
    @IBAction func toggleLoPass(_ sender: UISwitch) {
        
        if loPassSwitch.isOn {
           // Switch high-pass filter on and make sure that it takes the new value of the slider if changed
           fxAudioPlayer.synthLoPass.start()
           fxAudioPlayer.setSynthLoPassMixValue(loPassMixSlider.value)
           fxAudioPlayer.setSynthLoPassQValue(loPassQSlider.value)
           fxAudioPlayer.setSynthLoPassFrequency(loPassFrequencySlider.value)
           synthLoPassToggle = true
       } else {
           // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.

           fxAudioPlayer.setSynthLoPassMixValue(Float(fxAudioPlayer.synthLoPass.dryWetMix))
           fxAudioPlayer.setSynthLoPassQValue(Float(fxAudioPlayer.synthLoPass.resonance))
           fxAudioPlayer.setSynthLoPassFrequency(Float(fxAudioPlayer.synthLoPass.cutoffFrequency))
           fxAudioPlayer.synthHiPass.stop()
           synthLoPassToggle = false
       }
    }
    
    @IBAction func setLoPassFrequencyValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setSynthLoPassFrequency(loPassFrequencySlider.value)
            loPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.synthLoPass.cutoffFrequency)
        } else {
            loPassValueLabel.text = String(format: "%0.0f", loPassFrequencySlider.value)
        }
        
    }
    
    @IBAction func setLoPassQValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setSynthLoPassQValue(loPassQSlider.value)
            loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.synthLoPass.resonance)
        } else {
            loPassQLabel.text = String(format: "%0.2f", loPassQSlider.value)
        }
    }
    
    @IBAction func setLoPassMixValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setSynthLoPassMixValue(loPassMixSlider.value)
            loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthLoPass.dryWetMix)
        } else {
            loPassMixLabel.text = String(format: "%0.2f", loPassMixSlider.value)
        }
    }
    
    @IBAction func toggleDistortion(_ sender: UISwitch) {
        
        if distortionSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.synthDistortion.start()
            fxAudioPlayer.setSynthDistortionPreGainValue(preGainSlider.value)
            fxAudioPlayer.setSynthDistortionPostGainValue(postGainSlider.value)
            fxAudioPlayer.setSynthDistortionPositiveShape(positiveShapeSlider.value)
            synthDistortionToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setSynthDistortionPreGainValue(Float(fxAudioPlayer.synthDistortion.pregain))
            fxAudioPlayer.setSynthDistortionPostGainValue(Float(fxAudioPlayer.synthDistortion.postgain))
            fxAudioPlayer.setSynthDistortionPositiveShape(Float(fxAudioPlayer.synthDistortion.positiveShapeParameter))
            fxAudioPlayer.synthDistortion.stop()
            synthDistortionToggle = false
        }
    }
    
    @IBAction func setPreGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setSynthDistortionPreGainValue(preGainSlider.value)
            preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.pregain)
        } else {
            preGainLabel.text = String(format: "%0.2f", preGainSlider.value)
        }
    }
    
    @IBAction func setPostGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setSynthDistortionPostGainValue(postGainSlider.value)
            postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.postgain)
        } else {
            postGainLabel.text = String(format: "%0.2f", postGainSlider.value)
        }
    }
    
    @IBAction func setPositiveShapeValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setSynthDistortionPositiveShape(positiveShapeSlider.value)
            positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.synthDistortion.positiveShapeParameter)
        } else {
            positiveShapeLabel.text = String(format: "%0.2f", positiveShapeSlider.value)
        }
        
    }
    
    @IBAction func setXPanValue(_ sender: UISlider) {
        fxAudioPlayer.setSynthXPan(xPanSlider.value)
        xPanLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPanner.x)
    }
    
    @IBAction func setYPanValue(_ sender: UISlider) {
        fxAudioPlayer.setSynthYPan(yPanSlider.value)
        yPanLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPanner.y)
    }
    
    @IBAction func setZPanValue(_ sender: UISlider) {
        fxAudioPlayer.setSynthZPan(zPanSlider.value)
        zPanLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPanner.z)
    }
    
    @IBAction func toggleChorus(_ sender: UISwitch) {
        
        if chorusSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.synthChorus.start()
            fxAudioPlayer.setSynthChorusMix(chorusMixSlider.value)
            fxAudioPlayer.setSynthChorusDepth(chorusDepthSlider.value)
            fxAudioPlayer.setSynthChorusFeedback(chorusFeedbackSlider.value)
            fxAudioPlayer.setSynthChorusFrequency(chorusFrequencySlider.value)
            synthChorusToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setSynthChorusMix(Float(fxAudioPlayer.synthChorus.dryWetMix))
            fxAudioPlayer.setSynthChorusDepth(Float(fxAudioPlayer.synthChorus.depth))
            fxAudioPlayer.setSynthChorusFeedback(Float(fxAudioPlayer.synthChorus.feedback))
            fxAudioPlayer.setSynthChorusFrequency(Float(fxAudioPlayer.synthChorus.frequency))
            fxAudioPlayer.synthChorus.stop()
            synthChorusToggle = false
        }
    }
    
    @IBAction func setChorusMixValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setSynthChorusMix(chorusMixSlider.value)
                chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.dryWetMix)
            } else {
                chorusMixLabel.text = String(format: "%0.2f", chorusMixSlider.value)
            }
    }
    
    @IBAction func setChorusDepthValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setSynthChorusDepth(chorusDepthSlider.value)
                chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.depth)
            } else {
                chorusDepthLabel.text = String(format: "%0.2f", chorusDepthSlider.value)
            }
    }
        
    @IBAction func setChorusFeedbackValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setSynthChorusFeedback(chorusFeedbackSlider.value)
                chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.feedback)
            } else {
                chorusFeedbackLabel.text = String(format: "%0.2f", chorusFeedbackSlider.value)
            }
    }
    
    @IBAction func setChorusFrequency(_ sender: UISlider) {
        if chorusSwitch.isOn {
               fxAudioPlayer.setSynthChorusFrequency(chorusFrequencySlider.value)
               chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.synthChorus.frequency)
           } else {
               chorusFrequencyLabel.text = String(format: "%0.2f", chorusFrequencySlider.value)
           }
    }
    
    @IBAction func togglePhaser(_ sender: UISwitch) {
        
        if phaserSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.synthPhaser.start()
            fxAudioPlayer.setSynthPhaserBPM(phaserBPMSlider.value)
            fxAudioPlayer.setSynthPhaserDepth(phaserDepthSlider.value)
            fxAudioPlayer.setSynthPhaserFeedback(phaserFeedbackSlider.value)
            synthPhaserToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setSynthPhaserBPM(Float(fxAudioPlayer.synthPhaser.lfoBPM))
            fxAudioPlayer.setSynthPhaserDepth(Float(fxAudioPlayer.synthPhaser.depth))
            fxAudioPlayer.setSynthPhaserFeedback(Float(fxAudioPlayer.synthPhaser.feedback))
            fxAudioPlayer.synthPhaser.stop()
            synthPhaserToggle = false
        }
    }
    
    @IBAction func setPhaserDepth(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setSynthPhaserDepth(phaserDepthSlider.value)
            phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.depth)
        } else {
            phaserDepthLabel.text = String(format: "%0.2f", phaserDepthSlider.value)
        }
    }
    
    @IBAction func setPhaserFeedback(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setSynthPhaserFeedback(phaserFeedbackSlider.value)
            phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.feedback)
        } else {
            phaserFeedbackLabel.text = String(format: "%0.2f", phaserFeedbackSlider.value)
        }
    }
    
    @IBAction func setPhaserBPM(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setSynthPhaserBPM(phaserBPMSlider.value)
            phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.synthPhaser.lfoBPM)
        } else {
            phaserBPMLabel.text = String(format: "%0.2f", phaserBPMSlider.value)
        }
        
    }
    
    @IBAction func toggleFlanger(_ sender: UISwitch) {
        
        if flangerSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.synthFlanger.start()
            fxAudioPlayer.setSynthFlangerMix(flangerMixSlider.value)
            fxAudioPlayer.setSynthFlangerDepth(flangerDepthSlider.value)
            fxAudioPlayer.setSynthFlangerFeedback(flangerFeedbackSlider.value)
            fxAudioPlayer.setSynthFlangerFrequency(flangerFrequencySlider.value)
            synthFlangerToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setSynthFlangerMix(Float(fxAudioPlayer.synthFlanger.dryWetMix))
            fxAudioPlayer.setSynthFlangerDepth(Float(fxAudioPlayer.synthFlanger.depth))
            fxAudioPlayer.setSynthFlangerFeedback(Float(fxAudioPlayer.synthFlanger.feedback))
            fxAudioPlayer.setSynthFlangerFrequency(Float(fxAudioPlayer.synthFlanger.frequency))
            fxAudioPlayer.synthFlanger.stop()
            synthFlangerToggle = false
        }
    }
    
    @IBAction func setFlangerMixValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setSynthFlangerMix(flangerMixSlider.value)
            flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.dryWetMix)
        } else {
            flangerMixLabel.text = String(format: "%0.2f", flangerMixSlider.value)
        }
    }
    
    
    @IBAction func setFlangerDepthValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setSynthFlangerDepth(flangerDepthSlider.value)
            flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.depth)
        } else {
            flangerDepthLabel.text = String(format: "%0.2f", flangerDepthSlider.value)
        }
    }
    
    @IBAction func setFlangerFeedbackValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setSynthFlangerFeedback(flangerFeedbackSlider.value)
            flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.feedback)
        } else {
            flangerFeedbackLabel.text = String(format: "%0.2f", flangerFeedbackSlider.value)
        }
        
    }
    
    @IBAction func setFlangerFrequency(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setSynthFlangerFrequency(flangerFrequencySlider.value)
            flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.synthFlanger.frequency)
        } else {
            flangerFrequencyLabel.text = String(format: "%0.2f", flangerFrequencySlider.value)
        }
    }
}

private var microphoneReverbStep: Int = 0
var microphoneReverbToggle = false
var microphoneDelayToggle = false
var microphoneHiPassToggle = false
var microphoneLoPassToggle = false
var microphoneDistortionToggle = false
var microphoneChorusToggle = false
var microphonePhaserToggle = false
var microphoneFlangerToggle = false

// MARK:- MICROPHONE AUDIO VIEW CONTROLLER -

class MicrophoneFXViewController: UIViewController {
    
    // MARK:- FOR COMMENTS, REFER TO DRUM MACHINE VIEW CONTROLLER, AS THEY ARE IDENTICAL
    
    // Reverb outlets
    // Dry-Wet Mix
    @IBOutlet var reverbMixSlider: UISlider!
    @IBOutlet var reverbMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var reverbSwitch: UISwitch!
    @IBOutlet var reverbPresetStepper: UIStepper!
    @IBOutlet var reverbPresetLabel: UILabel!
    
    // Delay outlets
    // Dry-Wet Mix
    @IBOutlet var delayMixSlider: UISlider!
    @IBOutlet var delayMixLabel: UILabel!
    // On/Off Switch
    @IBOutlet var delaySwitch: UISwitch!
    // Delay Time
    @IBOutlet var delayTimeSlider: UISlider!
    @IBOutlet var delayTimeLabel: UILabel!
    // Feedback
    @IBOutlet var delayFeedbackSlider: UISlider!
    @IBOutlet var delayFeedbackLabel: UILabel!
    
    // High Pass Filter Outlets
    @IBOutlet var hiPassSwitch: UISwitch!
    @IBOutlet var hiPassFrequencySlider: UISlider!
    @IBOutlet var hiPassValueLabel: UILabel!
    @IBOutlet var hiPassQSlider: UISlider!
    @IBOutlet var hiPassQLabel: UILabel!
    @IBOutlet var hiPassMixSlider: UISlider!
    @IBOutlet var hiPassMixLabel: UILabel!
    
    // Low Pass Filter Outlets
    @IBOutlet var loPassSwitch: UISwitch!
    @IBOutlet var loPassFrequencySlider: UISlider!
    @IBOutlet var loPassValueLabel: UILabel!
    @IBOutlet var loPassQSlider: UISlider!
    @IBOutlet var loPassQLabel: UILabel!
    @IBOutlet var loPassMixSlider: UISlider!
    @IBOutlet var loPassMixLabel: UILabel!
    
    // Distortion Outlets
    @IBOutlet var distortionSwitch: UISwitch!
    @IBOutlet var preGainSlider: UISlider!
    @IBOutlet var preGainLabel: UILabel!
    @IBOutlet var postGainSlider: UISlider!
    @IBOutlet var postGainLabel: UILabel!
    @IBOutlet var positiveShapeSlider: UISlider!
    @IBOutlet var positiveShapeLabel: UILabel!
    
    // Panning Outlets
    @IBOutlet var xPanSlider: UISlider!
    @IBOutlet var xPanLabel: UILabel!
    @IBOutlet var yPanSlider: UISlider!
    @IBOutlet var yPanLabel: UILabel!
    @IBOutlet var zPanSlider: UISlider!
    @IBOutlet var zPanLabel: UILabel!
    
    // Chorus Outlets
    @IBOutlet var chorusSwitch: UISwitch!
    @IBOutlet var chorusMixSlider: UISlider!
    @IBOutlet var chorusMixLabel: UILabel!
    @IBOutlet var chorusDepthSlider: UISlider!
    @IBOutlet var chorusDepthLabel: UILabel!
    @IBOutlet var chorusFeedbackSlider: UISlider!
    @IBOutlet var chorusFeedbackLabel: UILabel!
    @IBOutlet var chorusFrequencySlider: UISlider!
    @IBOutlet var chorusFrequencyLabel: UILabel!
    
    // Phaser Outlets
    @IBOutlet var phaserSwitch: UISwitch!
    @IBOutlet var phaserDepthSlider: UISlider!
    @IBOutlet var phaserDepthLabel: UILabel!
    @IBOutlet var phaserFeedbackSlider: UISlider!
    @IBOutlet var phaserFeedbackLabel: UILabel!
    @IBOutlet var phaserBPMSlider: UISlider!
    @IBOutlet var phaserBPMLabel: UILabel!
    
    // Flanger Outlets
    @IBOutlet var flangerSwitch: UISwitch!
    @IBOutlet var flangerMixSlider: UISlider!
    @IBOutlet var flangerMixLabel: UILabel!
    @IBOutlet var flangerDepthSlider: UISlider!
    @IBOutlet var flangerDepthLabel: UILabel!
    @IBOutlet var flangerFeedbackSlider: UISlider!
    @IBOutlet var flangerFeedbackLabel: UILabel!
    @IBOutlet var flangerFrequencySlider: UISlider!
    @IBOutlet var flangerFrequencyLabel: UILabel!
    
    //@IBOutlet var pickerView: UIPickerView!
    
    private let reverbRooms = ["Small Room", "Medium Room", "Large Room", "Medium Hall", "Large Hall", "Medium Chamber", "Cathedral", "Plate"]
    
    /* Function that gets called each time the Keyboard FX Processor View loads */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if firstTime == true {
            firstTime = false
            fxAudioPlayer = FXAudioPlayer()
        }
        /* re-initialise each slider/label so their data is kept between segues */
        /* reverb  properties */
        reverbSwitch.isOn = microphoneReverbToggle
        delaySwitch.isOn = microphoneDelayToggle
        distortionSwitch.isOn = microphoneDistortionToggle
        hiPassSwitch.isOn = microphoneHiPassToggle
        loPassSwitch.isOn = microphoneLoPassToggle
        chorusSwitch.isOn = microphoneChorusToggle
        flangerSwitch.isOn = microphoneFlangerToggle
        phaserSwitch.isOn = microphonePhaserToggle
        
        reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneReverb.dryWetMix)
        reverbMixSlider.value = Float(fxAudioPlayer.microphoneReverb.dryWetMix.value())
        reverbPresetStepper.value = Double(microphoneReverbStep)
        reverbPresetLabel.text = String(reverbRooms[microphoneReverbStep])
        
        delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.time)
        delayTimeSlider.value = Float(fxAudioPlayer.microphoneDelay.time)
        delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.feedback)
        delayFeedbackSlider.value = Float(fxAudioPlayer.microphoneDelay.feedback)
        delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.dryWetMix)
        delayMixSlider.value = Float(fxAudioPlayer.microphoneDelay.dryWetMix)
        
        hiPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneHiPass.cutoffFrequency)
        hiPassFrequencySlider.value = Float(fxAudioPlayer.microphoneHiPass.cutoffFrequency)
        hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneHiPass.dryWetMix)
        hiPassMixSlider.value = Float(fxAudioPlayer.microphoneHiPass.dryWetMix)
        hiPassQSlider.value = Float(fxAudioPlayer.microphoneHiPass.resonance)
        hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneHiPass.resonance)
        
        loPassQSlider.value = Float(fxAudioPlayer.microphoneLoPass.resonance)
        loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneLoPass.resonance)
        loPassValueLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneLoPass.cutoffFrequency)
        loPassFrequencySlider.value = Float(fxAudioPlayer.microphoneLoPass.cutoffFrequency)
        loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneLoPass.dryWetMix)
        loPassMixSlider.value = Float(fxAudioPlayer.microphoneLoPass.dryWetMix)
        
        preGainSlider.value = Float(fxAudioPlayer.microphoneDistortion.pregain)
        preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.pregain)
        postGainSlider.value = Float(fxAudioPlayer.microphoneDistortion.postgain)
        postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.postgain)
        positiveShapeSlider.value = Float(fxAudioPlayer.microphoneDistortion.positiveShapeParameter)
        positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.positiveShapeParameter)
        
        chorusMixSlider.value = Float(fxAudioPlayer.microphoneChorus.dryWetMix)
        chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.dryWetMix)
        chorusDepthSlider.value = Float(fxAudioPlayer.microphoneChorus.depth)
        chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.depth)
        chorusFeedbackSlider.value = Float(fxAudioPlayer.microphoneChorus.feedback)
        chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.feedback)
        chorusFrequencySlider.value = Float(fxAudioPlayer.microphoneChorus.frequency)
        chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.frequency)
        
        phaserDepthSlider.value = Float(fxAudioPlayer.microphonePhaser.depth)
        phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.depth)
        phaserFeedbackSlider.value = Float(fxAudioPlayer.microphonePhaser.feedback)
        phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.feedback)
        phaserBPMSlider.value = Float(fxAudioPlayer.microphonePhaser.lfoBPM)
        phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.lfoBPM)

        flangerMixSlider.value = Float(fxAudioPlayer.microphoneFlanger.dryWetMix)
        flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.dryWetMix)
        flangerDepthSlider.value = Float(fxAudioPlayer.microphoneFlanger.depth)
        flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.depth)
        flangerFeedbackSlider.value = Float(fxAudioPlayer.microphoneFlanger.feedback)
        flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.feedback)
        flangerFrequencySlider.value = Float(fxAudioPlayer.microphoneFlanger.frequency)
        flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.frequency)
        
        xPanSlider.value = Float(fxAudioPlayer.microphonePanner.x)
        yPanSlider.value = Float(fxAudioPlayer.microphonePanner.y)
        zPanSlider.value = Float(fxAudioPlayer.microphonePanner.z)

        
    }

    
    @IBAction func toggleReverb(_ sender: Any) {
        if reverbSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphoneReverb.start()
            fxAudioPlayer.setMicReverbMixValue(reverbMixSlider.value)
            microphoneReverbToggle = true
        } else {
            // Keep track of the value of the slider whilst reverb is off and equate amount of reverb to slider value.
            fxAudioPlayer.microphoneReverb.stop()
            fxAudioPlayer.setMicReverbMixValue(Float(fxAudioPlayer.microphoneReverb.dryWetMix))
            
            microphoneReverbToggle = false
            
        }
    }
    
    @IBAction func setReverbMixValue(_ sender: UISlider) { // Called when slider is moved
        
        // Call the corresponding function in the reverbAudioPlayer class
        if reverbSwitch.isOn == true {
            reverbMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneReverb.dryWetMix)
            fxAudioPlayer.setMicReverbMixValue(reverbMixSlider.value)
            
        } else {
            reverbMixLabel.text = String(format: "%0.2f", reverbMixSlider.value)
        }
    }
    
    @IBAction func setReverbPreset(_ sender: UIStepper) {
        switch (sender.value) {
        case 0: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.smallRoom)
            reverbPresetLabel.text = String(reverbRooms[0])
        case 1: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.mediumRoom)
            reverbPresetLabel.text = String(reverbRooms[1])
        case 2: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.largeRoom)
            reverbPresetLabel.text = String(reverbRooms[2])
        case 3: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.mediumHall)
            reverbPresetLabel.text = String(reverbRooms[3])
        case 4: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.largeHall)
            reverbPresetLabel.text = String(reverbRooms[4])
        case 5: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.mediumChamber)
            reverbPresetLabel.text = String(reverbRooms[5])
        case 6: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.cathedral)
            reverbPresetLabel.text = String(reverbRooms[6])
        case 7: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.plate)
            reverbPresetLabel.text = String(reverbRooms[7])
        default: fxAudioPlayer.microphoneReverb.loadFactoryPreset(.smallRoom)
        }
        microphoneReverbStep = Int(sender.value)
    }

    @IBAction func toggleDelay(_ sender: UISwitch) {
        
        if delaySwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphoneDelay.start()
            fxAudioPlayer.setMicDelayTimeValue(delayTimeSlider.value)
            fxAudioPlayer.setMicDelayFeedbackValue(delayFeedbackSlider.value)
            fxAudioPlayer.setMicDelayMixValue(delayMixSlider.value)
            microphoneDelayToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setMicDelayFeedbackValue(Float(fxAudioPlayer.microphoneDelay.feedback))
            fxAudioPlayer.setMicDelayTimeValue(Float(fxAudioPlayer.microphoneDelay.time))
            fxAudioPlayer.setMicDelayMixValue(Float(fxAudioPlayer.microphoneDelay.dryWetMix))
            fxAudioPlayer.microphoneDelay.stop()
            microphoneDelayToggle = false
        }
    }
    
    @IBAction func setDelayMixValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setMicDelayMixValue(delayMixSlider.value)
            delayMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.dryWetMix)
        } else {
            delayMixLabel.text = String(format: "%0.2f", delayMixSlider.value)
        }
    }
    
    @IBAction func setDelayTimeValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setMicDelayTimeValue(delayTimeSlider.value)
            delayTimeLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.time)
        } else {
            delayTimeLabel.text = String(format: "%0.2f", delayTimeSlider.value)
        }
    }
    
    @IBAction func setDelayFeedbackValue(_ sender: UISlider) {
        if delaySwitch.isOn == true {
            fxAudioPlayer.setMicDelayFeedbackValue(delayFeedbackSlider.value)
            delayFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDelay.feedback)
        } else {
            delayFeedbackLabel.text = String(format: "%0.2f", delayFeedbackSlider.value)
        }
    }
    
    @IBAction func toggleHiPass(_ sender: UISwitch) {
        
        if hiPassSwitch.isOn {
               // Switch high-pass filter on and make sure that it takes the new value of the slider if changed
               fxAudioPlayer.microphoneHiPass.start()
               fxAudioPlayer.setMicHiPassMixValue(hiPassMixSlider.value)
               fxAudioPlayer.setMicHiPassQValue(hiPassQSlider.value)
               fxAudioPlayer.setMicHiPassFrequency(hiPassFrequencySlider.value)
               microphoneHiPassToggle = true
           } else {
               // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.

               fxAudioPlayer.setMicHiPassMixValue(Float(fxAudioPlayer.microphoneHiPass.dryWetMix))
               fxAudioPlayer.setMicHiPassQValue(Float(fxAudioPlayer.microphoneHiPass.resonance))
               fxAudioPlayer.setMicHiPassFrequency(Float(fxAudioPlayer.microphoneHiPass.cutoffFrequency))
               fxAudioPlayer.microphoneHiPass.stop()
               microphoneHiPassToggle = false
           }
        }
        
    @IBAction func setHiPassFrequencyValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setMicHiPassFrequency(hiPassFrequencySlider.value)
            hiPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.microphoneHiPass.cutoffFrequency)
        } else {
            hiPassValueLabel.text = String(format: "%0.0f", hiPassFrequencySlider.value)
        }
    }
    
    @IBAction func setHiPassQValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setMicHiPassQValue(hiPassQSlider.value)
            hiPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneHiPass.resonance)
        } else {
            hiPassQLabel.text = String(format: "%0.2f", hiPassQSlider.value)
        }
    }
    
    @IBAction func setHiPassMixValue(_ sender: UISlider) {
        if hiPassSwitch.isOn {
            fxAudioPlayer.setMicHiPassMixValue(hiPassMixSlider.value)
            hiPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneHiPass.dryWetMix)
        } else {
            hiPassMixLabel.text = String(format: "%0.2f", hiPassMixSlider.value)
        }
    }
    
    @IBAction func toggleLoPass(_ sender: UISwitch) {
        
        if loPassSwitch.isOn {
           // Switch high-pass filter on and make sure that it takes the new value of the slider if changed
           fxAudioPlayer.microphoneLoPass.start()
           fxAudioPlayer.setMicLoPassMixValue(loPassMixSlider.value)
           fxAudioPlayer.setMicLoPassQValue(loPassQSlider.value)
           fxAudioPlayer.setMicLoPassFrequency(loPassFrequencySlider.value)
           microphoneLoPassToggle = true
       } else {
           // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
           fxAudioPlayer.setMicLoPassMixValue(Float(fxAudioPlayer.microphoneLoPass.dryWetMix))
           fxAudioPlayer.setMicLoPassQValue(Float(fxAudioPlayer.microphoneLoPass.resonance))
           fxAudioPlayer.setMicLoPassFrequency(Float(fxAudioPlayer.microphoneLoPass.cutoffFrequency))
           fxAudioPlayer.microphoneHiPass.stop()
           microphoneLoPassToggle = false
       }
    }
    
    @IBAction func setLoPassFrequencyValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setMicLoPassFrequency(loPassFrequencySlider.value)
            loPassValueLabel.text = String(format: "%0.0f", fxAudioPlayer.microphoneLoPass.cutoffFrequency)
        } else {
            loPassValueLabel.text = String(format: "%0.0f", loPassFrequencySlider.value)
        }
        
    }
    
    @IBAction func setLoPassQValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setMicLoPassQValue(loPassQSlider.value)
            loPassQLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneLoPass.resonance)
        } else {
            loPassQLabel.text = String(format: "%0.2f", loPassQSlider.value)
        }
    }
    
    @IBAction func setLoPassMixValue(_ sender: UISlider) {
        if loPassSwitch.isOn {
            fxAudioPlayer.setMicLoPassMixValue(loPassMixSlider.value)
            loPassMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneLoPass.dryWetMix)
        } else {
            loPassMixLabel.text = String(format: "%0.2f", loPassMixSlider.value)
        }
    }
    
    @IBAction func toggleDistortion(_ sender: UISwitch) {
        
        if distortionSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphoneDistortion.start()
            fxAudioPlayer.setMicDistortionPreGainValue(preGainSlider.value)
            fxAudioPlayer.setMicDistortionPostGainValue(postGainSlider.value)
            fxAudioPlayer.setMicDistortionPositiveShape(positiveShapeSlider.value)
            microphoneDistortionToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setMicDistortionPreGainValue(Float(fxAudioPlayer.microphoneDistortion.pregain))
            fxAudioPlayer.setMicDistortionPostGainValue(Float(fxAudioPlayer.microphoneDistortion.postgain))
            fxAudioPlayer.setMicDistortionPositiveShape(Float(fxAudioPlayer.microphoneDistortion.positiveShapeParameter))
            fxAudioPlayer.microphoneDistortion.stop()
            microphoneDistortionToggle = false
        }
    }
    
    @IBAction func setPreGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setMicDistortionPreGainValue(preGainSlider.value)
            preGainLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.pregain)
        } else {
            preGainLabel.text = String(format: "%0.2f", preGainSlider.value)
        }
    }
    
    @IBAction func setPostGainValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setMicDistortionPostGainValue(postGainSlider.value)
            postGainLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.postgain)
        } else {
            postGainLabel.text = String(format: "%0.2f", postGainSlider.value)
        }
    }
    
    @IBAction func setPositiveShapeValue(_ sender: UISlider) {
        if distortionSwitch.isOn {
            fxAudioPlayer.setMicDistortionPositiveShape(positiveShapeSlider.value)
            positiveShapeLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneDistortion.positiveShapeParameter)
        } else {
            positiveShapeLabel.text = String(format: "%0.2f", positiveShapeSlider.value)
        }
        
    }
    
    @IBAction func setXPanValue(_ sender: UISlider) {
        fxAudioPlayer.setMicXPan(xPanSlider.value)
        xPanLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePanner.x)
    }
    
    @IBAction func setYPanValue(_ sender: UISlider) {
        fxAudioPlayer.setMicYPan(yPanSlider.value)
        yPanLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePanner.y)
    }
    
    @IBAction func setZPanValue(_ sender: UISlider) {
        fxAudioPlayer.setMicZPan(zPanSlider.value)
        zPanLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePanner.z)
    }
    
    @IBAction func toggleChorus(_ sender: UISwitch) {
        
        if chorusSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphoneChorus.start()
            fxAudioPlayer.setMicChorusMix(chorusMixSlider.value)
            fxAudioPlayer.setMicChorusDepth(chorusDepthSlider.value)
            fxAudioPlayer.setMicChorusFeedback(chorusFeedbackSlider.value)
            fxAudioPlayer.setMicChorusFrequency(chorusFrequencySlider.value)
            microphoneChorusToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setMicChorusMix(Float(fxAudioPlayer.microphoneChorus.dryWetMix))
            fxAudioPlayer.setMicChorusDepth(Float(fxAudioPlayer.microphoneChorus.depth))
            fxAudioPlayer.setMicChorusFeedback(Float(fxAudioPlayer.microphoneChorus.feedback))
            fxAudioPlayer.setMicChorusFrequency(Float(fxAudioPlayer.microphoneChorus.frequency))
            fxAudioPlayer.microphoneChorus.stop()
            microphoneChorusToggle = false
        }
    }
    
    @IBAction func setChorusMixValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setMicChorusMix(chorusMixSlider.value)
                chorusMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.dryWetMix)
            } else {
                chorusMixLabel.text = String(format: "%0.2f", chorusMixSlider.value)
            }
    }
    
    @IBAction func setChorusDepthValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setMicChorusDepth(chorusDepthSlider.value)
                chorusDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.depth)
            } else {
                chorusDepthLabel.text = String(format: "%0.2f", chorusDepthSlider.value)
            }
    }
        
    @IBAction func setChorusFeedbackValue(_ sender: UISlider) {
        if chorusSwitch.isOn {
                fxAudioPlayer.setMicChorusFeedback(chorusFeedbackSlider.value)
                chorusFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.feedback)
            } else {
                chorusFeedbackLabel.text = String(format: "%0.2f", chorusFeedbackSlider.value)
            }
    }
    
    @IBAction func setChorusFrequency(_ sender: UISlider) {
        if chorusSwitch.isOn {
               fxAudioPlayer.setMicChorusFrequency(chorusFrequencySlider.value)
               chorusFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneChorus.frequency)
           } else {
               chorusFrequencyLabel.text = String(format: "%0.2f", chorusFrequencySlider.value)
           }
    }
    
    @IBAction func togglePhaser(_ sender: UISwitch) {
        
        if phaserSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphonePhaser.start()
            fxAudioPlayer.setMicPhaserBPM(phaserBPMSlider.value)
            fxAudioPlayer.setMicPhaserDepth(phaserDepthSlider.value)
            fxAudioPlayer.setMicPhaserFeedback(phaserFeedbackSlider.value)
            microphonePhaserToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setMicPhaserBPM(Float(fxAudioPlayer.microphonePhaser.lfoBPM))
            fxAudioPlayer.setMicPhaserDepth(Float(fxAudioPlayer.microphonePhaser.depth))
            fxAudioPlayer.setMicPhaserFeedback(Float(fxAudioPlayer.microphonePhaser.feedback))
            fxAudioPlayer.microphonePhaser.stop()
            microphonePhaserToggle = false
        }
    }
    
    @IBAction func setPhaserDepth(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setMicPhaserDepth(phaserDepthSlider.value)
            phaserDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.depth)
        } else {
            phaserDepthLabel.text = String(format: "%0.2f", phaserDepthSlider.value)
        }
    }
    
    @IBAction func setPhaserFeedback(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setMicPhaserFeedback(phaserFeedbackSlider.value)
            phaserFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.feedback)
        } else {
            phaserFeedbackLabel.text = String(format: "%0.2f", phaserFeedbackSlider.value)
        }
    }
    
    @IBAction func setPhaserBPM(_ sender: UISlider) {
        if phaserSwitch.isOn {
            fxAudioPlayer.setMicPhaserBPM(phaserBPMSlider.value)
            phaserBPMLabel.text = String(format: "%0.2f", fxAudioPlayer.microphonePhaser.lfoBPM)
        } else {
            phaserBPMLabel.text = String(format: "%0.2f", phaserBPMSlider.value)
        }
        
    }
    
    @IBAction func toggleFlanger(_ sender: UISwitch) {
        
        if flangerSwitch.isOn {
            // Switch reverb on and make sure that it takes the new value of the slider if changed
            fxAudioPlayer.microphoneFlanger.start()
            fxAudioPlayer.setMicFlangerMix(flangerMixSlider.value)
            fxAudioPlayer.setMicFlangerDepth(flangerDepthSlider.value)
            fxAudioPlayer.setMicFlangerFeedback(flangerFeedbackSlider.value)
            fxAudioPlayer.setMicFlangerFrequency(flangerFrequencySlider.value)
            microphoneFlangerToggle = true
        } else {
            // Keep track of the value of the slider whilst delay is off and equate amount of delay to slider value.
            fxAudioPlayer.setMicFlangerMix(Float(fxAudioPlayer.microphoneFlanger.dryWetMix))
            fxAudioPlayer.setMicFlangerDepth(Float(fxAudioPlayer.microphoneFlanger.depth))
            fxAudioPlayer.setMicFlangerFeedback(Float(fxAudioPlayer.microphoneFlanger.feedback))
            fxAudioPlayer.setMicFlangerFrequency(Float(fxAudioPlayer.microphoneFlanger.frequency))
            fxAudioPlayer.microphoneFlanger.stop()
            microphoneFlangerToggle = false
        }
    }
    
    @IBAction func setFlangerMixValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setMicFlangerMix(flangerMixSlider.value)
            flangerMixLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.dryWetMix)
        } else {
            flangerMixLabel.text = String(format: "%0.2f", flangerMixSlider.value)
        }
        
    }
    
    @IBAction func setFlangerDepthValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setMicFlangerDepth(flangerDepthSlider.value)
            flangerDepthLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.depth)
        } else {
            flangerDepthLabel.text = String(format: "%0.2f", flangerDepthSlider.value)
        }
    }
    
    @IBAction func setFlangerFeedbackValue(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setMicFlangerFeedback(flangerFeedbackSlider.value)
            flangerFeedbackLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.feedback)
        } else {
            flangerFeedbackLabel.text = String(format: "%0.2f", flangerFeedbackSlider.value)
        }
        
    }
    
    @IBAction func setFlangerFrequency(_ sender: UISlider) {
        if flangerSwitch.isOn {
            fxAudioPlayer.setMicFlangerFrequency(flangerFrequencySlider.value)
            flangerFrequencyLabel.text = String(format: "%0.2f", fxAudioPlayer.microphoneFlanger.frequency)
        } else {
            flangerFrequencyLabel.text = String(format: "%0.2f", flangerFrequencySlider.value)
        }
    }
    
}


