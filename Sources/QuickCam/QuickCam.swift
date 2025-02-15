//
//  CameraView.swift
//  QuickCam
//
//  Created by Kim Nguyen on 14.02.24.
//

import SwiftUI

public struct QuickCamView<OverLay: View>: View {
    private let cameraSession: CameraSession
    private let overLay: OverLay
    private let onImageCaptured: (UIImage) -> Void

    public init(
        cameraSession: CameraSession,
        onImageCaptured: @escaping (UIImage) -> Void,
        @ViewBuilder overLay: () -> OverLay
    ) {
        self.cameraSession = cameraSession
        self.onImageCaptured = onImageCaptured
        self.overLay = overLay()
    }
    
    public init(
        cameraSession: CameraSession,
        onImageCaptured: @escaping (UIImage) -> Void
    ) where OverLay == DefaultOverLay {
        self.init(
            cameraSession: cameraSession,
            onImageCaptured: onImageCaptured,
            overLay: {
                DefaultOverLay(
                    onButtonTap: {
                        Task { [weak cameraSession] in
                            guard let cameraSession else { return }
                            do {
                                let image = try await cameraSession.capturePhoto()
                                onImageCaptured(image)
                            } catch {
                                
                            }
                        }
                    }
                )
            }
        )
    }

    public var body: some View {
        ZStack {
            CameraPreview(captureSession: cameraSession.captureSession)
            overLay
        }
    }
}

public struct DefaultOverLay: View {
    let onButtonTap: () -> Void
    
    public init(onButtonTap: @escaping () -> Void) {
        self.onButtonTap = onButtonTap
    }

    public var body: some View {
        VStack {
            Spacer()
            Button {
                onButtonTap()
            } label: {
                Circle()
                    .fill(Color.white)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                            .padding(4)
                    )
            }
        }
        .padding()
    }
}

