//
//  IntroViewController.swift
//  PunMe
//
//  Created by Dominic Whyte on 11/11/16.
//  Copyright © 2016 Dominic Whyte. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices



class IntroViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var introScreen: UIView!
    
    @IBOutlet weak var termsAndConditions: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var library: UIButton!
    @IBOutlet weak var camera: UIButton!
    var imagePicked: UIImageView!
    
    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var launchButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var dashboard: UIView!
    
    let picker = UIImagePickerController()
    
    let errorMessage = ["Take a better picture!", "Hmm.. Try again, please!"]
    
    //terms and conditions tapped
    func didTapLabelDemo(sender: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Use at your own risk", message: "We are not responsible for any fatalities resulting from the quality of our puns", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Let's go!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        //dashboard.backgroundColor = UIColor.white
        //dashboard.layer.cornerRadius = 30.0
        //dashboard.layer.borderColor = UIColor.black.cgColor
        //dashboard.layer.borderWidth = 4
        //dashboard.clipsToBounds = true
        
        screen.isHidden = true
        activityIndicator.isHidden = true
        
        termsAndConditions.isUserInteractionEnabled = true // Remember to do this
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapLabelDemo))
        termsAndConditions.addGestureRecognizer(tap)
        tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
        
        
        
        picker.delegate = self
        
        //logo.alpha = 0
        super.viewDidLoad()
        
        launchButton.alpha = 0
        descriptionLabel.alpha = 0
        termsAndConditions.alpha = 0
        
        //resultLabel.isHidden = true
        //setGradientBackground()
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Terms and Conditions")
        attributeString.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        termsAndConditions.attributedText = attributeString
        
        launchButton.layer.cornerRadius = 10.0
        //launchButton.layer.borderColor = UIColor.black.cgColor
        //launchButton.layer.borderWidth = 3
        launchButton.clipsToBounds = true
        
        camera.layer.cornerRadius = 10.0
        //camera.layer.borderColor = UIColor.black.cgColor
        //camera.layer.borderWidth = 3
        camera.clipsToBounds = true
        
        library.layer.cornerRadius = 10.0
        //library.layer.borderColor = UIColor.black.cgColor
        //library.layer.borderWidth = 3
        library.clipsToBounds = true
        
        library.isHidden = true
        camera.isHidden = true
        
        
        
    }
    
    //open the camera
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            //imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryClicked(_ sender: Any) {
        photoFromLibrary()
    }
    
    
    @IBAction func cameraClicked(_ sender: Any) {
        openCameraButton()
    }
    
    //    func openPhotoLibraryButton() {
    //        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
    //            let imagePicker = UIImagePickerController()
    //            imagePicker.delegate = self
    //            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
    //            imagePicker.allowsEditing = true
    //            self.present(imagePicker, animated: true, completion: nil)
    //        }
    //    }
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.mediaTypes = [kUTTypeImage as String]
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    //save the image
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func saveImage(image : UIImage) {
        
        
        
        UIImageWriteToSavedPhotosAlbum(textToImage(drawText: "hello", inImage: image, atPoint: CGPoint(x: (image.cgImage?.width)! / 2, y: (image.cgImage?.height)! / 2)), nil, nil, nil)

        
        
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        //add gradients to uiviews
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
//        launchButton.layer.insertSublayer(gradient, at: 0)
        
//        dark blue of p
//        57 93 214
//        107 167 246
//        
//        light blue of p
//        104 205 252
//        241 250 255
        
        let lightDark = UIColor(red: 57/255, green: 93/255, blue: 214/255, alpha: 1.0).cgColor
        let darkDark = UIColor(red: 107/255, green: 167/255, blue: 246/255, alpha: 1.0).cgColor
        
        let lightLight = UIColor(red: 104/255, green: 205/255, blue: 252/255, alpha: 1.0).cgColor
        let darkLight = UIColor(red: 241/255, green: 250/255, blue: 255/255, alpha: 1.0).cgColor
        
        applyGradient(aView: introScreen, color1: darkLight, color2: lightLight)
        applyGradient(aView: dashboard, color1: lightLight, color2: darkLight)
        applyGradient(aView: launchButton, color1: lightDark, color2: darkDark)
        applyGradient(aView: camera, color1: lightDark, color2: darkDark)
        applyGradient(aView: library, color1: lightDark, color2: darkDark)
        
        descriptionLabel.textColor = UIColor(red: 57/255, green: 93/255, blue: 214/255, alpha: 1.0)
        termsAndConditions.textColor = UIColor(red: 57/255, green: 93/255, blue: 214/255, alpha: 1.0)
        //launchButton.backgroundColor = UIColor.red
    }
    
    func applyGradient(aView : UIView, color1 : CGColor, color2 : CGColor) {
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = aView.bounds
        
        let cor1 = color1
        let cor2 = color2
        let arrayColors = [cor1, cor2]
        
        gradient.colors = arrayColors
        aView.layer.insertSublayer(gradient, at: 0)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = newImage
        } else{
            print("Something went wrong")
        }
        resultLabel.isHidden = true
        activityIndicator.isHidden = false
        screen.isHidden = false
        activityIndicator.startAnimating()
        
        dismiss(animated: true)
        camera.isHidden = true
        library.isHidden = true
        launchButton.isHidden = false
        
        if (selectedImage.image != nil) {
            
            uploadImage(
                selectedImage.image!,
                progress: { [unowned self] percent in
                    // 2
                    //self.progressView.setProgress(percent, animated: true)
                },
                completion: { pun in
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.screen.isHidden = true
                        self.activityIndicator.stopAnimating()
                        
                        let randomIndex = Int(arc4random_uniform(UInt32(self.errorMessage.count)))
                        
                        var newPun : String = self.errorMessage[randomIndex]
                        var word = ""
                        if (pun != nil) {
                            if let dict = convertStringToDictionary(data: pun!) {
                                if (dict["pun"] != nil && dict["word"] != nil) {
                                    newPun = (dict["pun"] as? String)!
                                    print("The pun is" + newPun)
                                    word = dict["word"] as! String
                                    //self.saveImage(image: self.selectedImage.image!)
                                }
                                else {
                                    self.resultLabel.text = newPun
                                }
                            }
                            else {
                                self.resultLabel.text = newPun
                            }
                        }
                        else {
                            self.resultLabel.text = newPun
                        }
                        
                        
                        
                        self.resultLabel.isHidden = false
                        print(newPun)
                        print(word)
                        self.resultLabel.attributedText = self.attributedText(pun: newPun, word: word)
                        
                        
                        
                    }
            })
        }
        
    }
    
    //bold certain word in a string
    func attributedText(pun : String, word : String)->NSAttributedString{
        
        let string = pun
        
        //        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)])
        //
        //        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
        //
        //        // Part of string to be bold
        //        attributedString.addAttributes(boldFontAttribute, range: string.range(of: word))
        
        
        let text = string
        let nsText = text as NSString
        let textRange = NSMakeRange(0, nsText.length)
        let attributedString = NSMutableAttributedString(string: text)
        
        nsText.enumerateSubstrings(in: textRange, options: .byWords, using: {
            (substring, substringRange, _, _) in
            
            if (substring?.lowercased() == word.lowercased()) {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: substringRange)
            }
        })
        // 4
        return attributedString
    }
    
    
    
    //fade in upon opening app
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchButton.fadeIn()
        descriptionLabel.fadeIn()
        termsAndConditions.fadeIn()
        
    }
    
    
    @IBAction func selectCamera(_ sender: Any) {
        
        launchButton.isHidden = true
        camera.isHidden = false
        library.isHidden = false
    }
}




//Extensions for UI Fade animations
extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    func fadeInPartially(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.7
        }, completion: completion)  }
    func fadeOut(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func fadeOutPartially(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0.4
        }, completion: completion)
    }
}


// Networking calls
extension UIViewController {
    func uploadImage(_ image: UIImage, progress: (_ percent: Float) -> Void,
                     completion: @escaping (_ pun: Data?) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        //initiate the upload
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //Specify what you want to send
            multipartFormData.append(imageData, withName: "file", fileName: "file", mimeType: "image/jpeg")
            //multipartFormData.append(imageData, withName: "file")
            //multipartFormData.append(imageData, withName: "file", mimeType: "image/jpeg")
            
            
        }, usingThreshold: UInt64.init(), to:  URL(string: "http://demo-deltice.boxfuse.io:8080/pun")!, method: .post, headers: ["Authorization" : "Basic xxx"], encodingCompletion: { (encodingResult) in
            
            //Once networking task is completed
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    guard response.result.isSuccess else {
                        print("Error while uploading file: \(response.result.error)")
                        completion(nil)
                        return
                    }
                    completion(response.data)
                })
                //                upload.responseString(completionHandler: { (response) in
                //
                //                    guard response.result.isSuccess else {
                //                        print("Error while uploading file: \(response.result.error)")
                //                        completion("Looking good there sir!")
                //                        return
                //                    }
                //                    completion(response.description)
                //
                //                })
                //                upload.responseJSON(completionHandler: { (response) in
                //                    guard response.result.isSuccess else {
                //                        print("Error while uploading file: \(response.result.error)")
                //                        completion("Looking good there sir!")
                //                        return
                //                    }
                //                    completion(response.description)
                //                })
                
                
                
                
            case .failure(let encodingError):
                print("encodingResult was a .failure")
                print(encodingError)
            }
            
            
            
        })
    }
}

func convertStringToDictionary(data: Data) -> [String:AnyObject]? {
    
    
    do {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
    } catch let error as NSError {
        print(error)
    }
    
    return nil
}





