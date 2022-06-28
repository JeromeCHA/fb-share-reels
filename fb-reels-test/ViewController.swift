//
//  ViewController.swift
//  fb-reels-test
//
//  Created by Jerome Cha on 2022/06/28.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedShareVideo() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        present(picker, animated: true, completion: nil)
    }
    
    private func shareToReels(url: URL) {
        guard let urlScheme = URL(string: "facebook-reels://share"),
                let backgroundVideo = try? Data(contentsOf: url) else { return }
        let appID = "<your_app_id>"
        if UIApplication.shared.canOpenURL(urlScheme) {
            let pasteboardItems: [[String : Any]] = [[
                "com.facebook.sharedSticker.backgroundVideo" : backgroundVideo,
                "com.facebook.sharedSticker.appID" : appID
            ]]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date(timeIntervalSinceNow: 60 * 5)]
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let movieUrl = info[.mediaURL] as? URL else { return }
        shareToReels(url: movieUrl)
    }
}

