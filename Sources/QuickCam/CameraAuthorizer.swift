//
//  CameraAuthorizer.swift
//  QuickCam
//
//  Created by Kim Nguyen on 14.02.24.
//

import AVFoundation

public protocol CameraAuthorization {
    func getCameraAuthorization() async -> Bool
}

public final class CameraAuthorizer: CameraAuthorization {
    public init() {}

    public func getCameraAuthorization() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        return switch status {
            // The user has previously granted access to the camera.
        case .authorized: true

            // The user has not yet been asked for camera access.
            // Privacy - Camera Usage Description (NSCameraUsageDescription) should be provided in Info.plist file
        case .notDetermined:
            await AVCaptureDevice.requestAccess(for: .video)

            // The user has previously denied access.
        case .denied: false

            // The user can't grant access due to restrictions.
        case .restricted: false

            // Unknown status
        @unknown default: false
        }
    }
}

