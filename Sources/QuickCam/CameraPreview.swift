//
//  CameraView.swift
//  QuickCam
//
//  Created by Kim Nguyen on 14.02.24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let captureSession: AVCaptureSession?

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        let previewLayer = view.videoPreviewLayer
        view.backgroundColor = .clear
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspect
        previewLayer.connection?.videoOrientation = .portrait
        return view
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {}

    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return (layer as? AVCaptureVideoPreviewLayer) ?? AVCaptureVideoPreviewLayer()
        }
    }
}

