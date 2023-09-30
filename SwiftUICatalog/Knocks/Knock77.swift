//
//  Knock77.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI
import AVFoundation
import CoreImage
enum Knock77 {
    struct ContentView: View {
        @StateObject var frameHandler = FrameHandler()
        var body: some View {
            GeometryReader(content: { reader in
                ZStack {
                    FrameView(image: frameHandler.frame)
                        .frame(maxWidth:  reader.size.width, maxHeight: reader.size.height).border(.black)
                        
                    Button(action: {
                        frameHandler.stop()
                    }, label: {
                        ZStack {
                            Color.white.frame(width: 70, height: 70).clipShape(Circle())
                                .shadow(color: .black, radius: 3)
                            
                            Color.red.frame(width: 60, height:  60).clipShape(Circle())
                        }
                        
                    }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding()
                }
            })
            
            .ignoresSafeArea()
            
            
        }
    }

    #Preview {
        Knock77.ContentView()
    }

}


struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
}


class FrameHandler: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var frame: CGImage?
    private var permissionGrangted = false
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let captureSession = AVCaptureSession()
    private let context = CIContext()
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async {
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for:.video) {
        case .authorized:
            permissionGrangted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGrangted = false
        } 
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] granted in
            self.permissionGrangted = granted
            
        })
    }
    
    func start() {
        captureSession.startRunning()
    }
    
    func stop() {
        captureSession.stopRunning()
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        guard permissionGrangted else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {
            return
        }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else {
            return
        }
        captureSession.addInput(videoDeviceInput)
        
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage  = makeCGImage(sampleBuffer) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    func makeCGImage(_ sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return cgImage
    }
    
}
