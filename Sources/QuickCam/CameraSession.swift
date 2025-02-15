//
//  CameraSession.swift
//  QuickCam
//
//  Created by Kim Nguyen on 14.02.24.
//

import UIKit
import AVFoundation

public final class CameraSession: NSObject, ObservableObject {
    public enum SessionError: Error {
        case cameraUnauthorized
        case creationFailure
    }

    private let photoOutput = AVCapturePhotoOutput()
    private let cameraAuthorizer: CameraAuthorization
    private let sessionPreset: AVCaptureSession.Preset
    private var photoCaptureContinuation: CheckedContinuation<UIImage, Error>?

    private(set) lazy var captureSession: AVCaptureSession? = {
        try? createCaptureSession()
    }()

    /// Initializes the Camera session.
    /// - Parameters:
    ///   - cameraAuthorizer: An object responsible for handling camera authorization.
    ///   - sessionPreset: The desired camera resolution preset.
    public init(
        cameraAuthorizer: CameraAuthorization = CameraAuthorizer(),
        sessionPreset: AVCaptureSession.Preset = .high
    ) {
        self.cameraAuthorizer = cameraAuthorizer
        self.sessionPreset = sessionPreset
        super.init()
    }

    /// Starts the camera session after checking for authorization.
    /// - Throws: `SessionError.cameraUnauthorized` if the user has denied camera access.
    public func start() async throws {
        guard await cameraAuthorizer.getCameraAuthorization() else {
            throw SessionError.cameraUnauthorized
        }

        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }

    public func stop() {
        captureSession?.stopRunning()
    }

    /// Captures a photo from the active camera session.
    /// - Returns: The captured `UIImage` if successful.
    /// - Throws: `PhotoCaptureError.noPhotoData` if no data is received,
    /// or `PhotoCaptureError.invalidImageData` if the data is corrupt.
    public func capturePhoto() async throws -> UIImage {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
        }

        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: PhotoCaptureError.noPhotoData)
                return
            }

            self.photoCaptureContinuation?.resume(throwing: CancellationError())
            self.photoCaptureContinuation = continuation
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }

    private func createCaptureSession() throws -> AVCaptureSession {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        guard
            let videoCaptureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
            captureSession.canAddInput(videoInput),
            captureSession.canAddOutput(photoOutput)
        else {
            throw SessionError.creationFailure
        }

        captureSession.sessionPreset = sessionPreset
        captureSession.addInput(videoInput)
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()

        return captureSession
    }
}

extension CameraSession: AVCapturePhotoCaptureDelegate {
    public enum PhotoCaptureError: Error {
        case noPhotoData
        case invalidImageData
    }

    public func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        defer { photoCaptureContinuation = nil }

        if let error {
            photoCaptureContinuation?.resume(throwing: error)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            photoCaptureContinuation?.resume(throwing: PhotoCaptureError.invalidImageData)
            return
        }

        photoCaptureContinuation?.resume(returning: image)
    }
}
