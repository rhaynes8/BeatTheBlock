// fxAudioPlayer.swift
//
import UIKit
import AudioKit

open class FXAudioPlayer {
    
    // Create variables for synthesiser nodes in order to change between waveforms
    var fmSynth: AKFMOscillatorBank
    var sawtoothSynth: AKFMOscillatorBank
    var sineSynth: AKFMOscillatorBank
    var squareSynth: AKOscillatorBank
    // Create a keyboard mixer, which will store each synth
    var keyboardMixer: AKMixer
    // Create constant for microphone input
    let microphone: AKMicrophone

    // Synth FX variables, which the keyboard mixer will chain to. This allows the four synthesiser nodes above to each have shared effects between transitions
    var synthReverb: AKReverb
    var synthDelay: AKDelay
    var synthHiPass: AKHighPassFilter
    var synthLoPass: AKLowPassFilter
    var synthDistortion: AKTanhDistortion
    var synthPanner: AK3DPanner
    var synthPhaser: AKPhaser
    var synthChorus: AKChorus
    var synthFlanger: AKFlanger
    var synthMixer: AKMixer
    
    // FX Variables for the drum machine samples
    var drumReverb: AKReverb
    var drumDelay: AKDelay
    var drumHiPass: AKHighPassFilter
    var drumLoPass: AKLowPassFilter
    var drumDistortion: AKTanhDistortion
    var drumPanner: AK3DPanner
    var drumPhaser: AKPhaser
    var drumChorus: AKChorus
    var drumFlanger: AKFlanger
    // Create a drum mixer to store all of the drum samples in so that they can all be affected by the FX Processor
    let drumMixer: AKMixer
    
    // FX Variables for the in-built microphone in the device. Allowing the user to sing or click with an effect such as reverb on the recording
    var microphoneReverb: AKReverb
    var microphoneDelay: AKDelay
    var microphoneHiPass: AKHighPassFilter
    var microphoneLoPass: AKLowPassFilter
    var microphoneDistortion: AKTanhDistortion
    var microphonePanner: AK3DPanner
    var microphonePhaser: AKPhaser
    var microphoneChorus: AKChorus
    var microphoneFlanger: AKFlanger
    var microphoneMixer: AKMixer
    
    // Create four recorders for each instrument, so that 4 tracks can be recorded on drums, 4 on synth, and 4 on voice.
    let synthOneRecorder: AKNodeRecorder
    let synthTwoRecorder: AKNodeRecorder
    let synthThreeRecorder: AKNodeRecorder
    let synthFourRecorder: AKNodeRecorder
    let drumsOneRecorder: AKNodeRecorder
    let drumsTwoRecorder: AKNodeRecorder
    let drumsThreeRecorder: AKNodeRecorder
    let drumsFourRecorder: AKNodeRecorder
    let micOneRecorder: AKNodeRecorder
    let micTwoRecorder: AKNodeRecorder
    let micThreeRecorder: AKNodeRecorder
    let micFourRecorder: AKNodeRecorder
    // Create constants for the tapes to write the recordings to, and the players to play the tape audio.
    // Each instrument needs 4 recorders, 4 tapes and 4 players
    let synthOneTape: AKAudioFile
    let synthOnePlayer: AKAudioPlayer
    let synthTwoTape: AKAudioFile
    let synthTwoPlayer: AKAudioPlayer
    let drumsOneTape: AKAudioFile
    let drumsOnePlayer: AKAudioPlayer
    let drumsTwoTape: AKAudioFile
    let drumsTwoPlayer: AKAudioPlayer
    let micOneTape: AKAudioFile
    let micOnePlayer: AKAudioPlayer
    let micTwoTape: AKAudioFile
    let micTwoPlayer: AKAudioPlayer
    let synthThreeTape: AKAudioFile
    let synthThreePlayer: AKAudioPlayer
    let synthFourTape: AKAudioFile
    let synthFourPlayer: AKAudioPlayer
    let drumsThreeTape: AKAudioFile
    let drumsThreePlayer: AKAudioPlayer
    let drumsFourTape: AKAudioFile
    let drumsFourPlayer: AKAudioPlayer
    let micThreeTape: AKAudioFile
    let micThreePlayer: AKAudioPlayer
    let micFourTape: AKAudioFile
    let micFourPlayer: AKAudioPlayer
    
    // Create a mixer that will have our output audio
    let mixer: AKMixer
    // Create a mixer for all our recordable instruments
    let recordingMixer: AKMixer
    
    // Create a metronome so that the user can easily keep in time whilst recording
    let metronome: AKMetronome
    
    // Variables for drum players, which will play each drum sample individually
    let kickPlayer: AKAudioPlayer
    let snarePlayer: AKAudioPlayer
    let openHiHatPlayer: AKAudioPlayer
    let closedHiHatPlayer: AKAudioPlayer
    let crashPlayer: AKAudioPlayer
    let ridePlayer: AKAudioPlayer
    let highTomPlayer: AKAudioPlayer
    let midTomPlayer: AKAudioPlayer
    let lowTomPlayer: AKAudioPlayer
    // Create a second set of players, so that a new audio file can start playing before the second has finished. This means a user can tap quickly on a sound file without having to worry about its length and whether it has finished.
    let kickTwoPlayer: AKAudioPlayer
    let snareTwoPlayer: AKAudioPlayer
    let openHiHatTwoPlayer: AKAudioPlayer
    let closedHiHatTwoPlayer: AKAudioPlayer
    let crashTwoPlayer: AKAudioPlayer
    let rideTwoPlayer: AKAudioPlayer
    let highTomTwoPlayer: AKAudioPlayer
    let midTomTwoPlayer: AKAudioPlayer
    let lowTomTwoPlayer: AKAudioPlayer

    
    
    
    init() {  // Runs once when the class is instantiated

        // Instantiate synth variables with different waveforms (sine, triangle, sawtooth and square)
        fmSynth = AKFMOscillatorBank(waveform: AKTable(.positiveTriangle))
        sawtoothSynth = AKFMOscillatorBank(waveform: AKTable(.positiveSawtooth))
        sineSynth = AKFMOscillatorBank(waveform: AKTable(.sine))
        squareSynth = AKOscillatorBank(waveform: AKTable(.positiveSquare, count: 4096))
        
        // Instantiate a microphone variable of type AKMicrophone
        microphone = AKMicrophone()!
        // Place each synthesiser node into the keyboard mixer
        keyboardMixer = AKMixer(fmSynth, sawtoothSynth, sineSynth, squareSynth)
        // Play the Keyboard Mixer through the synth mixer for FX processing
        synthMixer = AKMixer(keyboardMixer)
        // Place the microphone in the microphone mixer
        microphoneMixer = AKMixer(microphone)
        // Set up each sample with its corresponding .wav file
        let kickSample = try! AKAudioFile(readFileName: "Bass.wav", baseDir: .resources)
        let snareSample = try! AKAudioFile(readFileName: "Snare.wav", baseDir: .resources)
        let openHiHatSample = try! AKAudioFile(readFileName: "openHiHat.wav", baseDir: .resources)
        let closedHiHatSample = try! AKAudioFile(readFileName: "closedHiHat.wav", baseDir: .resources)
        let crashSample = try! AKAudioFile(readFileName: "Crash.wav", baseDir: .resources)
        let rideSample = try! AKAudioFile(readFileName: "Ride.wav", baseDir: .resources)
        let highTomSample = try! AKAudioFile(readFileName: "TomHi.wav", baseDir: .resources)
        let midTomSample = try! AKAudioFile(readFileName: "TomMid.wav", baseDir: .resources)
        let lowTomSample = try! AKAudioFile(readFileName: "TomLow.wav", baseDir: .resources)
        
        // Set microphone's initial volume to 0 to avoid feedback if a user isn't wearing headphones
        microphone.volume = 0

        // Create drum players to play the read-in samples
        kickPlayer = try! AKAudioPlayer(file: kickSample)
        snarePlayer = try! AKAudioPlayer(file: snareSample)
        snarePlayer.volume = 4.0
        openHiHatPlayer = try! AKAudioPlayer(file: openHiHatSample)
        closedHiHatPlayer = try! AKAudioPlayer(file: closedHiHatSample)
        closedHiHatPlayer.volume = 4.0
        crashPlayer = try! AKAudioPlayer(file: crashSample)
        ridePlayer = try! AKAudioPlayer(file: rideSample)
        highTomPlayer = try! AKAudioPlayer(file: highTomSample)
        midTomPlayer = try! AKAudioPlayer(file: midTomSample)
        lowTomPlayer = try! AKAudioPlayer(file: lowTomSample)
        // Create secondary drum players to read in the second set of samples for quick button presses
        kickTwoPlayer = try! AKAudioPlayer(file: kickSample)
        snareTwoPlayer = try! AKAudioPlayer(file: snareSample)
        snareTwoPlayer.volume = 4.0
        openHiHatTwoPlayer = try! AKAudioPlayer(file: openHiHatSample)
        closedHiHatTwoPlayer = try! AKAudioPlayer(file: closedHiHatSample)
        closedHiHatTwoPlayer.volume = 4.0
        crashTwoPlayer = try! AKAudioPlayer(file: crashSample)
        rideTwoPlayer = try! AKAudioPlayer(file: rideSample)
        highTomTwoPlayer = try! AKAudioPlayer(file: highTomSample)
        midTomTwoPlayer = try! AKAudioPlayer(file: midTomSample)
        lowTomTwoPlayer = try! AKAudioPlayer(file: lowTomSample)

        // Mix each possible drum sound into a drum mixer ready for processing
        drumMixer = AKMixer(kickPlayer, snarePlayer, openHiHatPlayer, closedHiHatPlayer, crashPlayer, ridePlayer, highTomPlayer, midTomPlayer, lowTomPlayer, kickTwoPlayer, snareTwoPlayer, openHiHatTwoPlayer, closedHiHatTwoPlayer, crashTwoPlayer, rideTwoPlayer, highTomTwoPlayer, midTomTwoPlayer, lowTomTwoPlayer)
        // Set the drum mixer's volume at 0.5
        drumMixer.volume = 0.5
      
        /* Chain Effect */
        // Pass each FX Node through the next one to create a chain of effects.
        synthReverb = AKReverb(synthMixer); synthDelay = AKDelay(synthReverb); synthHiPass = AKHighPassFilter(synthDelay)
        synthLoPass = AKLowPassFilter(synthHiPass);
        synthDistortion = AKTanhDistortion(synthLoPass); synthChorus = AKChorus(synthDistortion)
        synthPhaser = AKPhaser(synthChorus); synthFlanger = AKFlanger(synthPhaser); synthPanner = AK3DPanner(synthFlanger)
        
        /* Drum Machines Effects */
        // Pass each FX Node through the next one to create a chain of effects.
        drumReverb = AKReverb(drumMixer); drumDelay = AKDelay(drumReverb); drumHiPass = AKHighPassFilter(drumDelay)
        drumLoPass = AKLowPassFilter(drumHiPass);
        drumDistortion = AKTanhDistortion(drumLoPass); drumChorus = AKChorus(drumDistortion)
        drumPhaser = AKPhaser(drumChorus); drumFlanger = AKFlanger(drumPhaser); drumPanner = AK3DPanner(drumFlanger)
        
        /* Microphone Effects */
        // Pass each FX Node through the next one to create a chain of effects.
        microphoneReverb = AKReverb(microphoneMixer); microphoneDelay = AKDelay(microphoneReverb); microphoneHiPass = AKHighPassFilter(microphoneDelay)
        microphoneLoPass = AKLowPassFilter(microphoneHiPass);
        microphoneDistortion = AKTanhDistortion(microphoneLoPass); microphoneChorus = AKChorus(microphoneDistortion)
        microphonePhaser = AKPhaser(microphoneChorus); microphoneFlanger = AKFlanger(microphonePhaser); microphonePanner = AK3DPanner(microphoneFlanger)
        
        // Instantiate the metronome
        metronome = AKMetronome()
        // Create a higher first beat of the bar to ensure user knows what beat they are on. Set tempo at 120, and beats per bar to 4.
        metronome.frequency1 = 1320; metronome.frequency2 = 880; metronome.tempo = 120; metronome.subdivision = 4
        /* Set Synthesiser FX properties and initial values */
        synthReverb.dryWetMix = 0.0;
        synthDelay.dryWetMix = 0.0; synthDelay.feedback = 0.0; synthDelay.time = 0.0
        synthHiPass.cutoffFrequency = 20; synthHiPass.dryWetMix = 1.0; synthHiPass.resonance = 0.0
        synthLoPass.cutoffFrequency = 20000; synthLoPass.dryWetMix = 1.0; synthLoPass.resonance = 0.0
        synthDistortion.postgain = 0.5; synthDistortion.pregain = 0.5; synthDistortion.positiveShapeParameter = 1
        synthChorus.depth = 0; synthChorus.dryWetMix = 0.0; synthChorus.feedback = 0.0; synthChorus.frequency = 20
        synthPhaser.depth = 0; synthPhaser.feedback = 0.0; synthPhaser.lfoBPM = 1;
        synthFlanger.depth = 0; synthFlanger.dryWetMix = 0.0; synthFlanger.feedback = 0.0; synthFlanger.frequency = 20
        
        /* Set Drum Machine's FX properties and initial values */
        drumReverb.dryWetMix = 0.0;
        drumDelay.dryWetMix = 0.0; drumDelay.feedback = 0.0; drumDelay.time = 0.0
        drumHiPass.cutoffFrequency = 20; drumHiPass.dryWetMix = 1.0; drumHiPass.resonance = 0.0
        drumLoPass.cutoffFrequency = 20000; drumLoPass.dryWetMix = 1.0; drumLoPass.resonance = 0.0
        drumDistortion.postgain = 0.5; drumDistortion.pregain = 0.5; drumDistortion.positiveShapeParameter = 1
        drumChorus.depth = 0; drumChorus.dryWetMix = 0.0; drumChorus.feedback = 0.0; drumChorus.frequency = 20
        drumPhaser.depth = 0; drumPhaser.feedback = 0.0; drumPhaser.lfoBPM = 1;
        drumFlanger.depth = 0; drumFlanger.dryWetMix = 0.0; drumFlanger.feedback = 0.0; drumFlanger.frequency = 20
        
        /* Set Microphone's FX properties and initial values */
        microphoneReverb.dryWetMix = 0.0;
        microphoneDelay.dryWetMix = 0.0; microphoneDelay.feedback = 0.0; microphoneDelay.time = 0.0
        microphoneHiPass.cutoffFrequency = 20; microphoneHiPass.dryWetMix = 1.0; microphoneHiPass.resonance = 0.0
        microphoneLoPass.cutoffFrequency = 20000; microphoneLoPass.dryWetMix = 1.0; microphoneLoPass.resonance = 0.0
        microphoneDistortion.postgain = 0.5; microphoneDistortion.pregain = 0.5; microphoneDistortion.positiveShapeParameter = 1
        microphoneChorus.depth = 0; microphoneChorus.dryWetMix = 0.0; microphoneChorus.feedback = 0.0; microphoneChorus.frequency = 20
        microphonePhaser.depth = 0; microphonePhaser.feedback = 0.0; microphonePhaser.lfoBPM = 1;
        microphoneFlanger.depth = 0; microphoneFlanger.dryWetMix = 0.0; microphoneFlanger.feedback = 0.0; microphoneFlanger.frequency = 20
        
        
        // Pass the tape, which will record audio, to the player that will be able to play it.
        // Needs to be done for each instrument 4 times.
        synthOneTape = try! AKAudioFile()
        synthOnePlayer = try! AKAudioPlayer(file: synthOneTape)
        synthTwoTape = try! AKAudioFile()
        synthTwoPlayer = try! AKAudioPlayer(file: synthTwoTape)
        drumsOneTape = try! AKAudioFile()
        drumsOnePlayer = try! AKAudioPlayer(file: drumsOneTape)
        drumsTwoTape = try! AKAudioFile()
        drumsTwoPlayer = try! AKAudioPlayer(file: drumsTwoTape)
        micOneTape = try! AKAudioFile()
        micOnePlayer = try! AKAudioPlayer(file: micOneTape)
        micTwoTape = try! AKAudioFile()
        micTwoPlayer = try! AKAudioPlayer(file: micTwoTape)
        synthThreeTape = try! AKAudioFile()
        synthThreePlayer = try! AKAudioPlayer(file: synthThreeTape)
        synthFourTape = try! AKAudioFile()
        synthFourPlayer = try! AKAudioPlayer(file: synthFourTape)
        drumsThreeTape = try! AKAudioFile()
        drumsThreePlayer = try! AKAudioPlayer(file: drumsThreeTape)
        drumsFourTape = try! AKAudioFile()
        drumsFourPlayer = try! AKAudioPlayer(file: drumsFourTape)
        micThreeTape = try! AKAudioFile()
        micThreePlayer = try! AKAudioPlayer(file: micThreeTape)
        micFourTape = try! AKAudioFile()
        micFourPlayer = try! AKAudioPlayer(file: micFourTape)
       
        // Mixer for recording instruments only
        recordingMixer = AKMixer(synthPanner, drumPanner, microphonePanner)
        // Let mixer go to Audio output with recording armed instruments mixer (i.e. not metronome) as an input to final mixer
        mixer = AKMixer(recordingMixer, metronome, synthOnePlayer, synthTwoPlayer, synthThreePlayer, synthFourPlayer, drumsOnePlayer, drumsTwoPlayer, drumsThreePlayer, drumsFourPlayer, micOnePlayer, micTwoPlayer, micThreePlayer, micFourPlayer)
                
        // Connect all possible sounds to the output, so they can be heard
        AudioKit.output = mixer
        // Start AudioKit
        try!AudioKit.start()
        
        // Instantiate the instrument recorders with the instruments to record, and the tapes to record to
        synthOneRecorder = try! AKNodeRecorder(node: recordingMixer, file: synthOneTape)
        synthTwoRecorder = try! AKNodeRecorder(node: recordingMixer, file: synthTwoTape)
        synthThreeRecorder = try! AKNodeRecorder(node: recordingMixer, file: synthThreeTape)
        synthFourRecorder = try! AKNodeRecorder(node: recordingMixer, file: synthFourTape)
        drumsOneRecorder = try! AKNodeRecorder(node: recordingMixer, file: drumsOneTape)
        drumsTwoRecorder = try! AKNodeRecorder(node: recordingMixer, file: drumsTwoTape)
        drumsThreeRecorder = try! AKNodeRecorder(node: recordingMixer, file: drumsThreeTape)
        drumsFourRecorder = try! AKNodeRecorder(node: recordingMixer, file: drumsFourTape)
        micOneRecorder = try! AKNodeRecorder(node: recordingMixer, file: micOneTape)
        micTwoRecorder = try! AKNodeRecorder(node: recordingMixer, file: micTwoTape)
        micThreeRecorder = try! AKNodeRecorder(node: recordingMixer, file: micThreeTape)
        micFourRecorder = try! AKNodeRecorder(node: recordingMixer, file: micFourTape)
        
    }
    
    // MARK: - FX and Pan Functions for Each Individual Audio Source
    /* Creating functions to change each FX Processor's parameters. The effects being used here are: Reverb, Delay, 3D Panning, High Pass Filter, Low Pass Filter, Chorus, Phaser and Flanger */

    // Synthesiser Reverb
    open func setSynthReverbMixValue(_ reverbMixValue: Float){
        synthReverb.dryWetMix = Double(reverbMixValue)
        
    }
    // Drum Machine Reverb
    open func setDrumsReverbMixValue(_ reverbMixValue: Float){
        drumReverb.dryWetMix = Double(reverbMixValue)
        
    }
    // Microphone Reverb
    open func setMicReverbMixValue(_ reverbMixValue: Float){
        microphoneReverb.dryWetMix = Double(reverbMixValue)
        
    }
    
    
    // Synth Delay
    open func setSynthDelayMixValue(_ delayMixValue: Float){
        synthDelay.dryWetMix = Double(delayMixValue)
    }
    open func setSynthDelayTimeValue(_ delayTimeValue: Float){
        synthDelay.time = Double(delayTimeValue)
    }
    open func setSynthDelayFeedbackValue(_ delayFeedbackValue: Float){
        synthDelay.feedback = Double(delayFeedbackValue)
    }
    // Drum Machine Delay
    open func setDrumsDelayMixValue(_ delayMixValue: Float){
        drumDelay.dryWetMix = Double(delayMixValue)
    }
    open func setDrumsDelayTimeValue(_ delayTimeValue: Float){
        drumDelay.time = Double(delayTimeValue)
    }
    open func setDrumsDelayFeedbackValue(_ delayFeedbackValue: Float){
        drumDelay.feedback = Double(delayFeedbackValue)
    }
    // Microphone Delay
    open func setMicDelayMixValue(_ delayMixValue: Float){
        microphoneDelay.dryWetMix = Double(delayMixValue)
    }
    open func setMicDelayTimeValue(_ delayTimeValue: Float){
        microphoneDelay.time = Double(delayTimeValue)
    }
    open func setMicDelayFeedbackValue(_ delayFeedbackValue: Float){
        microphoneDelay.feedback = Double(delayFeedbackValue)
    }
    
    // Synth HiPass
    open func setSynthHiPassFrequency(_ hiPassValue: Float){
        synthHiPass.cutoffFrequency = Double(hiPassValue)
    }
    open func setSynthHiPassMixValue(_ hiPassMixValue: Float){
        synthHiPass.dryWetMix = Double(hiPassMixValue)
    }
    open func setSynthHiPassQValue(_ hiPassQValue: Float){
        synthHiPass.resonance = Double(hiPassQValue)
    }
    // Drum Machines HiPass
    open func setDrumsHiPassFrequency(_ hiPassValue: Float){
        drumHiPass.cutoffFrequency = Double(hiPassValue)
    }
    open func setDrumsHiPassMixValue(_ hiPassMixValue: Float){
        drumHiPass.dryWetMix = Double(hiPassMixValue)
    }
    open func setDrumsHiPassQValue(_ hiPassQValue: Float){
        drumHiPass.resonance = Double(hiPassQValue)
    }
    // Microphone HiPass
    open func setMicHiPassFrequency(_ hiPassValue: Float){
        microphoneHiPass.cutoffFrequency = Double(hiPassValue)
    }
    open func setMicHiPassMixValue(_ hiPassMixValue: Float){
        microphoneHiPass.dryWetMix = Double(hiPassMixValue)
    }
    open func setMicHiPassQValue(_ hiPassQValue: Float){
        microphoneHiPass.resonance = Double(hiPassQValue)
    }

    // Synth LoPass
    open func setSynthLoPassFrequency(_ loPassValue: Float){
        synthLoPass.cutoffFrequency = Double(loPassValue)
    }
    open func setSynthLoPassMixValue(_ loPassMixValue: Float){
        synthLoPass.dryWetMix = Double(loPassMixValue)
    }
    open func setSynthLoPassQValue(_ loPassQValue: Float){
        synthLoPass.resonance = Double(loPassQValue)
    }
    // Drum Machines LoPass
    open func setDrumsLoPassFrequency(_ loPassValue: Float){
        drumLoPass.cutoffFrequency = Double(loPassValue)
    }
    open func setDrumsLoPassMixValue(_ loPassMixValue: Float){
        drumLoPass.dryWetMix = Double(loPassMixValue)
    }
    open func setDrumsLoPassQValue(_ loPassQValue: Float){
        drumLoPass.resonance = Double(loPassQValue)
    }
    // Microphone LoPass
    open func setMicLoPassFrequency(_ loPassValue: Float){
        microphoneLoPass.cutoffFrequency = Double(loPassValue)
    }
    open func setMicLoPassMixValue(_ loPassMixValue: Float){
        microphoneLoPass.dryWetMix = Double(loPassMixValue)
    }
    open func setMicLoPassQValue(_ loPassQValue: Float){
        microphoneLoPass.resonance = Double(loPassQValue)
    }

    // Synth Distortion
    open func setSynthDistortionPreGainValue(_ preGainValue: Float){
        synthDistortion.pregain = Double(preGainValue)
    }
    open func setSynthDistortionPostGainValue(_ postGainValue: Float){
        synthDistortion.postgain = Double(postGainValue)
    }
    open func setSynthDistortionPositiveShape(_ posiShapeValue: Float){
        synthDistortion.positiveShapeParameter = Double(posiShapeValue)
    }
    // Drum Machine Distortion
    open func setDrumsDistortionPreGainValue(_ preGainValue: Float){
        drumDistortion.pregain = Double(preGainValue)
    }
    open func setDrumsDistortionPostGainValue(_ postGainValue: Float){
        drumDistortion.postgain = Double(postGainValue)
    }
    open func setDrumsDistortionPositiveShape(_ posiShapeValue: Float){
        drumDistortion.positiveShapeParameter = Double(posiShapeValue)
    }
    // Microphone Distortion
    open func setMicDistortionPreGainValue(_ preGainValue: Float){
        microphoneDistortion.pregain = Double(preGainValue)
    }
    open func setMicDistortionPostGainValue(_ postGainValue: Float){
        microphoneDistortion.postgain = Double(postGainValue)
    }
    open func setMicDistortionPositiveShape(_ posiShapeValue: Float){
        microphoneDistortion.positiveShapeParameter = Double(posiShapeValue)
    }

    //Synth Chorus
    open func setSynthChorusDepth(_ chorusDepthValue: Float){
        synthChorus.depth = Double(chorusDepthValue)
    }
    open func setSynthChorusMix(_ chorusMixValue: Float){
        synthChorus.dryWetMix = Double(chorusMixValue)
    }
    open func setSynthChorusFeedback(_ chorusFeedbackValue: Float){
        synthChorus.feedback = Double(chorusFeedbackValue)
    }
    open func setSynthChorusFrequency(_ chorusFrequencyValue: Float){
        synthChorus.frequency = Double(chorusFrequencyValue)
    }
    // Drum Machine Chorus
    open func setDrumsChorusDepth(_ chorusDepthValue: Float){
        drumChorus.depth = Double(chorusDepthValue)
    }
    open func setDrumsChorusMix(_ chorusMixValue: Float){
        drumChorus.dryWetMix = Double(chorusMixValue)
    }
    open func setDrumsChorusFeedback(_ chorusFeedbackValue: Float){
        drumChorus.feedback = Double(chorusFeedbackValue)
    }
    open func setDrumsChorusFrequency(_ chorusFrequencyValue: Float){
        drumChorus.frequency = Double(chorusFrequencyValue)
    }
    // Microphone Chorus
    open func setMicChorusDepth(_ chorusDepthValue: Float){
        microphoneChorus.depth = Double(chorusDepthValue)
    }
    open func setMicChorusMix(_ chorusMixValue: Float){
        microphoneChorus.dryWetMix = Double(chorusMixValue)
    }
    open func setMicChorusFeedback(_ chorusFeedbackValue: Float){
        microphoneChorus.feedback = Double(chorusFeedbackValue)
    }
    open func setMicChorusFrequency(_ chorusFrequencyValue: Float){
        microphoneChorus.frequency = Double(chorusFrequencyValue)
    }
    

    // Synth Phaser
    open func setSynthPhaserDepth(_ phaserDepthValue: Float){
        synthPhaser.depth = Double(phaserDepthValue)
    }
    open func setSynthPhaserFeedback(_ phaserFeedbackValue: Float){
        synthPhaser.feedback = Double(phaserFeedbackValue)
    }
    open func setSynthPhaserBPM(_ phaserBPMValue: Float){
        synthPhaser.lfoBPM = Double(phaserBPMValue)
    }
    // Drum Machine Phaser
    open func setDrumsPhaserDepth(_ phaserDepthValue: Float){
        drumPhaser.depth = Double(phaserDepthValue)
    }
    open func setDrumsPhaserFeedback(_ phaserFeedbackValue: Float){
        drumPhaser.feedback = Double(phaserFeedbackValue)
    }
    open func setDrumsPhaserBPM(_ phaserBPMValue: Float){
        drumPhaser.lfoBPM = Double(phaserBPMValue)
    }
    // Microphone Phaser
    open func setMicPhaserDepth(_ phaserDepthValue: Float){
        microphonePhaser.depth = Double(phaserDepthValue)
    }
    open func setMicPhaserFeedback(_ phaserFeedbackValue: Float){
        microphonePhaser.feedback = Double(phaserFeedbackValue)
    }
    open func setMicPhaserBPM(_ phaserBPMValue: Float){
        microphonePhaser.lfoBPM = Double(phaserBPMValue)
    }
    

    // Synth Flanger
    open func setSynthFlangerDepth(_ flangerDepthValue: Float){
        synthFlanger.depth = Double(flangerDepthValue)
    }
    open func setSynthFlangerMix(_ flangerMixValue: Float){
        synthFlanger.dryWetMix = Double(flangerMixValue)
    }
    open func setSynthFlangerFeedback(_ flangerFeedbackValue: Float){
        synthFlanger.feedback = Double(flangerFeedbackValue)
    }
    open func setSynthFlangerFrequency(_ flangerFrequencyValue: Float){
        synthFlanger.frequency = Double(flangerFrequencyValue)
    }
    // Drum Machine Flanger
    open func setDrumsFlangerDepth(_ flangerDepthValue: Float){
        drumFlanger.depth = Double(flangerDepthValue)
    }
    open func setDrumsFlangerMix(_ flangerMixValue: Float){
        drumFlanger.dryWetMix = Double(flangerMixValue)
    }
    open func setDrumsFlangerFeedback(_ flangerFeedbackValue: Float){
        drumFlanger.feedback = Double(flangerFeedbackValue)
    }
    open func setDrumsFlangerFrequency(_ flangerFrequencyValue: Float){
        drumFlanger.frequency = Double(flangerFrequencyValue)
    }
    // Microphone Flanger
    open func setMicFlangerDepth(_ flangerDepthValue: Float){
        microphoneFlanger.depth = Double(flangerDepthValue)
    }
    open func setMicFlangerMix(_ flangerMixValue: Float){
        microphoneFlanger.dryWetMix = Double(flangerMixValue)
    }
    open func setMicFlangerFeedback(_ flangerFeedbackValue: Float){
        microphoneFlanger.feedback = Double(flangerFeedbackValue)
    }
    open func setMicFlangerFrequency(_ flangerFrequencyValue: Float){
        microphoneFlanger.frequency = Double(flangerFrequencyValue)
    }
    

    // Synth 3D Panning
    open func setSynthXPan(_ XPanValue: Float) {
           synthPanner.x = Double(XPanValue)
       }
    open func setSynthYPan(_ YPanValue: Float) {
        synthPanner.y = Double(YPanValue)
    }
    open func setSynthZPan(_ ZPanValue: Float) {
        synthPanner.z = Double(ZPanValue)
    }
    // Drum Machine 3D Panning
    open func setDrumsXPan(_ XPanValue: Float) {
        drumPanner.x = Double(XPanValue)
    }
    open func setDrumsYPan(_ YPanValue: Float) {
        drumPanner.y = Double(YPanValue)
    }
    open func setDrumsZPan(_ ZPanValue: Float) {
        drumPanner.z = Double(ZPanValue)
    }
    // Microphone 3D Panning
    open func setMicXPan(_ XPanValue: Float) {
        microphonePanner.x = Double(XPanValue)
    }
    open func setMicYPan(_ YPanValue: Float) {
        microphonePanner.y = Double(YPanValue)
    }
    open func setMicZPan(_ ZPanValue: Float) {
        microphonePanner.z = Double(ZPanValue)
    }
    
    // Set pitch bend value for synthesisers
    open func setPitchBend(_ PitchBendValue: Float){
        fmSynth.pitchBend = Double(PitchBendValue)
    }
    
    //  MARK:- <KEYBOARD/NOTE FUNCTIONS> -
   
    /* These functions enable notes to be played from button pushes. They take in the octave of the keyboard, the velocity and the current wave form being played */
    
    /* Functions for playing C notes */
    open func playC(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        switch instrument{
            // Play C at mf.
            // Multiply a C midi note by the amount of octaves to reach that same note at that octave.
            // Switch case present for different synthesiser
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(12*octave)), velocity: MIDIVelocity(velocity))
            print("Triangle")
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(12*octave)), velocity: MIDIVelocity(velocity))
            print("Sawtooth")
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(12*octave)), velocity: MIDIVelocity(velocity)) // Play C below middle C at mf// Play C below middle C at mf
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(12*octave)), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(12*octave)), velocity: MIDIVelocity(velocity)) // Play C below middle C at mf
        }
    }
    /* A function to stop the note once the button has been lifted */
    open func stopC(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(12*octave)))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(12*octave)))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(12*octave)))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(12*octave)))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(12*octave)))
        }
    }

    
    /* Functions for playing C# notes */
    open func playCSharp(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        // Play C# at mf.
        // Multiply a C# midi note by the amount of octaves to reach that same note at that octave.
        // Switch case present for different synthesiser
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(1+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(1+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(1+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(1+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(1+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    /* Function for stopping all C#s */
    open func stopCSharp(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(1+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(1+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(1+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(1+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(1+(12*octave))))
        }
    }
    
    /* Functions for playing D notes */
    open func playD(_ octave: Int,_ velocity: Int,_ instrument: Int) {
         // Play D below at mf
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(2+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(2+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(2+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(2+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(2+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    /* Function for stopping all Ds */
    open func stopD(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(2+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(2+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(2+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(2+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(2+(12*octave))))
        }
    }
    
    /* Functions for playing D# notes */
    open func playDSharp(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        // Play D# at mf
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(3+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(3+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(3+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(3+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(3+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    
    /* Function for stopping all D#s */
    open func stopDSharp(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(3+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(3+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(3+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(3+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(3+(12*octave))))
        }
    }
    
    /* Functiones for playing E notes */
    open func playE(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        // Play E at mf
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(4+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(4+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(4+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(4+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(4+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    /* Function for stopping all Es */
    open func stopE(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(4+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(4+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(4+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(4+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(4+(12*octave))))
        }
    }
    
    /* Function for playing F notes */
    open func playF(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        // Play F at mf
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(5+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(5+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(5+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(5+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(5+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    /* Function for stopping all Fs */
    open func stopF(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(5+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(5+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(5+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(5+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(5+(12*octave))))
        }
    }
    
    /* Functions for playing F# notes */
    open func playFSharp(_ octave: Int,_ velocity: Int,_ instrument: Int) {
         // Play F# at mf
               switch instrument{
                   case 2: fmSynth.play(noteNumber:(MIDINoteNumber(6+(12*octave))), velocity: MIDIVelocity(velocity))
                   case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(6+(12*octave))), velocity: MIDIVelocity(velocity))
                   case 0: sineSynth.play(noteNumber:(MIDINoteNumber(6+(12*octave))), velocity: MIDIVelocity(velocity))
                   case 3: squareSynth.play(noteNumber:(MIDINoteNumber(6+(12*octave))), velocity: MIDIVelocity(velocity))
               default:fmSynth.play(noteNumber:(MIDINoteNumber(6+(12*octave))), velocity: MIDIVelocity(velocity))
               }
    }
    /* Function for stopping all F#s */
    open func stopFSharp(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(6+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(6+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(6+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(6+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(6+(12*octave))))
        }
    }
    
    /* Function for playing G notes */
    open func playG(_ octave: Int,_ velocity: Int,_ instrument: Int) {
         // Play G at mf
           switch instrument{
               case 2: fmSynth.play(noteNumber:(MIDINoteNumber(7+(12*octave))), velocity: MIDIVelocity(velocity))
               case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(7+(12*octave))), velocity: MIDIVelocity(velocity))
               case 0: sineSynth.play(noteNumber:(MIDINoteNumber(7+(12*octave))), velocity: MIDIVelocity(velocity))
               case 3: squareSynth.play(noteNumber:(MIDINoteNumber(7+(12*octave))), velocity: MIDIVelocity(velocity))
           default:fmSynth.play(noteNumber:(MIDINoteNumber(7+(12*octave))), velocity: MIDIVelocity(velocity))
           }
    }
    /* Function for stopping all Gs */
    open func stopG(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(7+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(7+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(7+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(7+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(7+(12*octave))))
        }
    }
    
    /* Function for playing G# notes */
    open func playGSharp(_ octave: Int,_ velocity: Int,_ instrument: Int) {
         // Play G# at mf
           switch instrument{
               case 2: fmSynth.play(noteNumber:(MIDINoteNumber(8+(12*octave))), velocity: MIDIVelocity(velocity))
               case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(8+(12*octave))), velocity: MIDIVelocity(velocity))
               case 0: sineSynth.play(noteNumber:(MIDINoteNumber(8+(12*octave))), velocity: MIDIVelocity(velocity))
               case 3: squareSynth.play(noteNumber:(MIDINoteNumber(8+(12*octave))), velocity: MIDIVelocity(velocity))
           default:fmSynth.play(noteNumber:(MIDINoteNumber(8+(12*octave))), velocity: MIDIVelocity(velocity))
           }
    }
    /* Function for stopping all G#s */
    open func stopGSharp(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(8+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(8+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(8+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(8+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(8+(12*octave))))
        }
    }
    
    /* Function for playing A notes */
    open func playA(_ octave: Int,_ velocity: Int,_ instrument: Int) {
         // Play A at mf
           switch instrument{
               case 2: fmSynth.play(noteNumber:(MIDINoteNumber(9+(12*octave))), velocity: MIDIVelocity(velocity))
               case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(9+(12*octave))), velocity: MIDIVelocity(velocity))
               case 0: sineSynth.play(noteNumber:(MIDINoteNumber(9+(12*octave))), velocity: MIDIVelocity(velocity))
               case 3: squareSynth.play(noteNumber:(MIDINoteNumber(9+(12*octave))), velocity: MIDIVelocity(velocity))
           default:fmSynth.play(noteNumber:(MIDINoteNumber(9+(12*octave))), velocity: MIDIVelocity(velocity))
           }
    }
    /* Function for stopping all As */
    open func stopA(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(9+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(9+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(9+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(9+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(9+(12*octave))))
        }
    }
    
    /* Function for playing A# notes */
    open func playASharp(_ octave: Int,_ velocity: Int,_ instrument: Int) {
     // Play E at mf
           switch instrument{
               case 2: fmSynth.play(noteNumber:(MIDINoteNumber(10+(12*octave))), velocity: MIDIVelocity(velocity))
               case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(10+(12*octave))), velocity: MIDIVelocity(velocity))
               case 0: sineSynth.play(noteNumber:(MIDINoteNumber(10+(12*octave))), velocity: MIDIVelocity(velocity))
               case 3: squareSynth.play(noteNumber:(MIDINoteNumber(10+(12*octave))), velocity: MIDIVelocity(velocity))
           default:fmSynth.play(noteNumber:(MIDINoteNumber(10+(12*octave))), velocity: MIDIVelocity(velocity))
           }
    }
    /* Function for stopping all As */
    open func stopASharp(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(10+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(10+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(10+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(10+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(10+(12*octave))))
        }
    }
    
    /* Functions for playing B notes */
    open func playB(_ octave: Int,_ velocity: Int,_ instrument: Int) {
          // Play B at mf
            switch instrument{
                case 2: fmSynth.play(noteNumber:(MIDINoteNumber(11+(12*octave))), velocity: MIDIVelocity(velocity))
                case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(11+(12*octave))), velocity: MIDIVelocity(velocity))
                case 0: sineSynth.play(noteNumber:(MIDINoteNumber(11+(12*octave))), velocity: MIDIVelocity(velocity))
                case 3: squareSynth.play(noteNumber:(MIDINoteNumber(11+(12*octave))), velocity: MIDIVelocity(velocity))
            default:fmSynth.play(noteNumber:(MIDINoteNumber(11+(12*octave))), velocity: MIDIVelocity(velocity))
            }
    }
    /* Function for stopping all Bs */
    open func stopB(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(11+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(11+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(11+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(11+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(11+(12*octave))))
        }
    }
    /* Functions for playing +8ve C notes */
    open func playCHigh(_ octave: Int,_ velocity: Int,_ instrument: Int) {
        // Play C at mf, +ve above original
        switch instrument{
            case 2: fmSynth.play(noteNumber:(MIDINoteNumber(12+(12*octave))), velocity: MIDIVelocity(velocity))
            case 1: sawtoothSynth.play(noteNumber:(MIDINoteNumber(12+(12*octave))), velocity: MIDIVelocity(velocity))
            case 0: sineSynth.play(noteNumber:(MIDINoteNumber(12+(12*octave))), velocity: MIDIVelocity(velocity))
            case 3: squareSynth.play(noteNumber:(MIDINoteNumber(12+(12*octave))), velocity: MIDIVelocity(velocity))
        default:fmSynth.play(noteNumber:(MIDINoteNumber(12+(12*octave))), velocity: MIDIVelocity(velocity))
        }
    }
    /* Function for stopping all +8ve C notes*/
    open func stopCHigh(_ octave: Int,_ instrument: Int) {
        switch instrument.value() {
        case 2: fmSynth.stop(noteNumber:(MIDINoteNumber(12+(12*octave))))
        case 1: sawtoothSynth.stop(noteNumber: (MIDINoteNumber(12+(12*octave))))
        case 0: sineSynth.stop(noteNumber: (MIDINoteNumber(12+(12*octave))))
        case 3: squareSynth.stop(noteNumber: (MIDINoteNumber(12+(12*octave))))
        default: fmSynth.stop(noteNumber:(MIDINoteNumber(12+(12*octave))))
        }
    }
}

