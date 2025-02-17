# QuickCam


## Features
- Quick start the camera and start capturing images


## Installation
### Using Swift Package Manager (SPM)
Follow Apple's guide for [adding a package dependency to your app]
```Swift
https://github.com/nguyenbakim/QuickCam.git
```
or
```Swift
git@github.com:nguyenbakim/QuickCam.git
```
### Manual
You can also manually copy the source code to your project
## Usage
- Open the Info.plist file and add the Privacy - Camera Usage Description (NSCameraUsageDescription)
- Using default overlay with a shutter button
```Swift
import SwiftUI
import QuickCam

struct ImageCaptureView: View {
    @State private var cameraSession: CameraSession?
    
    var body: some View {
        VStack {
            if let cameraSession {
                QuickCamView(
                    cameraSession: cameraSession,
                    onImageCaptured: { image in
                        // hande image
                    }
                )
            } else {
                ProgressView()
                    .task {
                        await startCamera()
                    }
            }
        }
        .onDisappear {
            cameraSession?.stop()
        }
    }
    
    private func startCamera() async {
        let session = CameraSession()
        do {
            try await session.start()
            cameraSession = session
        } catch {
            // hanlde error
        }
    }
}
```


[adding a package dependency to your app]: <https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app>
