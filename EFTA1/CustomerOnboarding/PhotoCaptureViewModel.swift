import SwiftUI

class PhotoCaptureViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var isPickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
}
