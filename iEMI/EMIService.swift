//
//  EMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/17/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

enum ServiceError: ErrorType {
    case RequestTimedOut
    case RequestFailed(description:String?)
    case ParametersSerializationError
    case ResponseParsingError
    case ResponseInformationError
    case ResponseErrorMessage(errorMessage:String?)
    case ResponseSuccessfullMessage(message:String?) //not really an error
    case RequestURLNotValid
}


class EMIService: NSObject {

    var baseURL: String = "http://w1.logo-sa.com.ar:8080/EMIW3/rest/"
    
    let session = NSURLSession.sharedSession()
    
    func get(url: String, parameters: Dictionary<String, String>?, completion: (response: () throws -> AnyObject?) -> Void) {
        
        guard NSURL(string: baseURL + url) != nil else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.RequestURLNotValid})
            })
            return
        }
        
        var requestURLString = baseURL + url
        
        if let requestParameters = parameters {
            if requestParameters.count > 0 {
                requestURLString += "?"
                for (parameterName, parameterValue) in requestParameters {
                    requestURLString += parameterName + "=" + parameterValue + "&"
                }
                requestURLString.removeAtIndex(requestURLString.endIndex.predecessor())
            }
        }
        
        guard let requestURL = NSURL(string: requestURLString) else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.ParametersSerializationError})
            })
            return;
        }
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) { [unowned self] data, response, error -> Void in
            
            guard error == nil else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {throw ServiceError.RequestFailed(description: error?.localizedDescription)})
                })
                return
            }
            
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {return nil})
                })
                return
            }
            
            self.parseResponseData(data, completion: completion)
        }
        
        task.resume()
    }
    
    func post(url: String, parameters: Dictionary<String, String>?, completion: (response: () throws -> AnyObject?) -> Void) {
        
        guard let requestURL = NSURL(string: baseURL + url) else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.RequestURLNotValid})
            })
            return
        }
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData

        if let requestParameters = parameters {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(requestParameters,options:NSJSONWritingOptions.PrettyPrinted)
            }
            catch {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {throw ServiceError.ParametersSerializationError})
                })
                return
            }
        }
        
        let task = session.dataTaskWithRequest(request) { [unowned self] data, response, error -> Void in
            
            guard error == nil else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {throw ServiceError.RequestFailed(description: error?.localizedDescription)})
                })
                return
            }
            
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {return nil})
                })
                return
            }
            
            self.parseResponseData(data, completion: completion)
        }
        
        task.resume()

    }
    
    private func parseResponseData(data: NSData,completion: (response: () throws -> AnyObject?) -> Void) {
        
        var responseJson : AnyObject? = nil
        
        do {
            responseJson = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            
        } catch {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.ResponseParsingError})
            })
            return
        }
        
        guard responseJson != nil else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.ResponseParsingError})
            })
            return
        }
        
        let responseMessages = responseJson as? [String:AnyObject]
        
        if let messages = responseMessages?["Messages"] as? [[String : AnyObject]] {
            //if we get the Messages field it's becouse the response have messages. If the message type is 1 it's an error.
            //Error message {"Messages":[{"Description":"PIN Incorrecto","Id":"","Type":1}]}
            //Message {"Messages":[{"Description":"Estacionamiento Finalizado CORRECTAMENTE!","Id":"","Type":0}]}
            
            if let message = messages.first {
                
                let messageType = message["Type"] as? Int
                let messageDescription = message["Description"] as? String

                if messageType == 0 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(response: {throw ServiceError.ResponseSuccessfullMessage(message: messageDescription)})
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(response: {throw ServiceError.ResponseErrorMessage(errorMessage: messageDescription)})
                    })
                }
                
            }else {
                //if the field messages is present but there is no messages -> the response is ok
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {return responseJson})
                })
            }
        } else {
            //if we didn't get "messages" -> the response is ok
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {return responseJson})
            })
        }

    }

}
