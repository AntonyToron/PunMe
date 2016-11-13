//
//  Model.swift
//  PunMe
//
//  Created by Dominic Whyte on 11/11/16.
//  Copyright © 2016 Dominic Whyte. All rights reserved.
//

import UIKit
import Alamofire



func myImageUploadRequest(_ newImage : UIImage)
{
    let imageData = UIImageJPEGRepresentation(newImage, 1)
    
    Alamofire.upload(imageData!, to: "https://httpbin.org/post").responseJSON { response in
        debugPrint(response)
    }

}





//    let myUrl = URL(string: "http://demo-deltice.boxfuse.io:8080/pun");
//    let request = NSMutableURLRequest(url: myUrl!)
//    request.httpMethod = "POST";
//    
//    let param = [
//        "firstName"  : "Sergey",
//        "lastName"    : "Kargopolov",
//        "userId"    : "9"
//    ]
//    
//    let boundary = generateBoundaryString()
//    
//    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//    
//    
//    let imageData = UIImageJPEGRepresentation(newImage, 1)
//    
//    if(imageData==nil)  { return; }
//    
//    request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: (imageData! as NSData) as Data, boundary: boundary) as Data
//    
//    //let body = NSMutableData()
//    //body.append(imageData! as Data)
//    
//    //request.httpBody = body as Data
//    
//    //myActivityIndicator.startAnimating();
//    print("Attempting to start URLSession")
//    let task = URLSession.shared.dataTask(with: request as URLRequest) {
//        data, response, error in
//        
//        if error != nil {
//            print("error=\(error)")
//            return
//        }
//        print("Success receiving response from URLSession")
//        
//        // You can print out response object
//        //print("******* response = \(response)")
//        
//        // Print out reponse body
//        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//        print("****** response data = \(responseString!)")
//        
//        do {
//            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
//            
//            //print(json)
//            DispatchQueue.main.async {
//                print("Update UI")
//            };
//            
//        }catch
//        {
//            print(error)
//        }
//        
//    }
//    
//    task.resume()



//func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
//    let body = NSMutableData();
//    var testString = ""
//    
//    if parameters != nil {
//        for (key, value) in parameters! {
//            testString.append("--\(boundary)\r\n")
//            testString.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            testString.append("\(value)\r\n")
//        }
//    }
//    
//    let filename = "user-profile.jpg"
//    let mimetype = "image/jpg"
//    
//    testString.append("--\(boundary)\r\n")
//    testString.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//    testString.append("Content-Type: \(mimetype)\r\n\r\n")
//    body.append(testString.data(using: .utf8)!)
//    body.append(imageDataKey as Data)
//    
//    body.append("\r\n".data(using: .utf8)!)
//    
//    
//    
//    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//    
//    return body as Data
//}
//
//
//
//func generateBoundaryString() -> String {
//    return "Boundary-\(UUID().uuidString)"
//}




