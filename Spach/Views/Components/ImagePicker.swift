import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
import UIKit
import PhotosUI
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

struct ImagePicker: View {
    @Binding var image: PlatformImage?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        #if os(iOS)
        IOSImagePicker(image: $image, onComplete: { dismiss() })
        #elseif os(macOS)
        MacImagePicker(image: $image, onComplete: { dismiss() })
        #endif
    }
}

#if os(iOS)
private struct IOSImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let onComplete: () -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var cfg = PHPickerConfiguration(photoLibrary: .shared())
        cfg.selectionLimit = 1
        cfg.filter = .images
        let pc = PHPickerViewController(configuration: cfg)
        pc.delegate = context.coordinator
        return pc
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: IOSImagePicker
        init(_ parent: IOSImagePicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            if let item = results.first?.itemProvider,
               item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { ui, _ in
                    DispatchQueue.main.async { self.parent.image = ui as? UIImage }
                }
            }
            parent.onComplete()
        }
    }
}
#endif

#if os(macOS)
private struct MacImagePicker: NSViewControllerRepresentable {
    @Binding var image: NSImage?
    let onComplete: () -> Void

    func makeNSViewController(context: Context) -> NSViewController {
        let vc = NSViewController()
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.allowedContentTypes = [.png, .jpeg, .heic, .heif, .tiff]
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.begin { response in
                if response == .OK, let url = panel.url,
                   let nsImg = NSImage(contentsOf: url) {
                    self.image = nsImg
                }
                self.onComplete()
            }
        }
        return vc
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
}
#endif
