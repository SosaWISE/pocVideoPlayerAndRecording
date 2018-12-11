//
//  ViewController.swift
//  POC-WelcomeCallSinglePage
//
//  Created by Andres Sosa on 12/10/18.
//  Copyright © 2018 Andres Sosa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // START UI PROPERTIES
    @IBOutlet weak var videoPlayerViewer: UIView!
    @IBOutlet weak var videoRecorderViewer: UIView!
    // END   UI PROPERTIES
    
    // START UI EVENTS
    
    /**
     * Entry point for starting recording
    */
    @IBAction func startButton(_ sender: Any) {
        // ** Show the stop button
        stopButtonOutlet.isHidden = false
        
        // ** Begin the recording session first
        print ("OK.  Start Button has been clicked.")
        
        // ** INIT
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureCameraAndAudioDevices()
        if captureDevice != nil {
            beginSession()
        }
    }

    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBAction func stopButton(_ sender: Any) {
        movieOutput.stopRecording()
    }
    // END   UI EVENTS
    
    // START CONTROLLER PROPERTIES
    var videoFilePath: URL?
    
    let captureSession = AVCaptureSession()
    var movieOutput = AVCaptureMovieFileOutput()
    
    var captureDevice: AVCaptureDevice?
    var captureAudio: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var frontCamera: Bool = true
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    // END   CONTROLLER PROPERTIES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ** Setup Initial UI Stuff
        stopButtonOutlet.isHidden = true;
    }
    
    // START MAIN METHODS
    func startRecording() {
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        print ("I want to know if we have a captureDevice: \(captureDevice)")

    }
    
    func captureCameraAndAudioDevices() {
        let devices = AVCaptureDevice.devices()
        
        // ** REMOVE ANY DEVICE ATTACHED TO THE SESSION.
        do {
            print ("******|======> Is captureDevice nil: \(captureDevice)")
            if (captureDevice == nil)  { return }
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice!))
        } catch let error {
            print("******|======> Error possible nil captureDevice: \(error.localizedDescription)")
        }
        
        // ** CAPTURE ONLY FRONT VIDEO
        for device in devices {
            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
                if (device as AnyObject).position == AVCaptureDevice.Position.front {
                    captureDevice = device as? AVCaptureDevice
                    
                    // ** CAPTURE VIDEO
                    do {
                        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
                        print("******|======> Captured the FRONT CAMERA")
                    } catch let error {
                        print("******|------> Error on position front captureDevice!: \(error.localizedDescription)")
                    }
                    
                    break
                }
            }
        }
        
        // ** CAPTURE AUDTIO
        for device in devices {
            if ((device as AnyObject).hasMediaType(AVMediaType.audio)) {
                captureAudio = device as? AVCaptureDevice
                
                // ** CAPTURE AUDIO
                do {
                    // ** PRINT CAPTURING AUDIO
                    print("|******|======> We are capturing Audio.")
                    try captureSession.addInput(AVCaptureDeviceInput(device: captureAudio!))
                    print("|******|======> Audio capturing was successfull.")
                    
                } catch let error {
                    print("|******|------> Error on capturing Audio.  \(error)")
                }
                
                break
            }
        }
    }
    // END   MAIN METHODS
}
