//
//  EMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/17/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class EMIService: NSObject, Service {

    var baseURL: String = "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/"
    
    let session = NSURLSession.sharedSession()
    
    func get(url: String, parameters: Dictionary<String, String>, completion: (response: () throws -> AnyObject?) -> Void) -> Void {
        
        var requestURLString = baseURL + url
        
        if parameters.count > 0 {
            
            requestURLString += "?"
            
            for (parameterName, parameterValue) in parameters {
                requestURLString += parameterName + "=" + parameterValue + "&"
            }
            
            requestURLString.removeAtIndex(requestURLString.endIndex.predecessor())
        }
    
        let requestURL = NSURL(string: requestURLString)
        if requestURL == nil {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.ParametersSerializationError})
            })
            return;
        }
        
        let request = NSMutableURLRequest(URL: requestURL!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {throw ServiceError.RequestFailed(description: error?.localizedDescription)})
                })
                
            } else if data == nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {return nil})
                })
                
            } else {
                
                do {
                    let responseData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    let responseMessages = responseData as? [String:AnyObject]
                    if let messages = responseMessages?["Messages"] as? [[String : AnyObject]] {
                        
                        if let message = messages.first {
                            let messageDescription = message["Description"] as? String
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(response: {throw ServiceError.ResponseErrorMessage(errorMessage: messageDescription)})
                            })
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(response: {return responseData})
                        })
                    }
                    
                } catch {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(response: {throw ServiceError.ResponseParsingError})
                    })
                }
            }
        }
        
        task.resume()
    }
    
    func post(url: String, parameters: Dictionary<String, String>, completion: (response: () throws -> AnyObject?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters,options:NSJSONWritingOptions.PrettyPrinted)
        }
        catch {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(response: {throw ServiceError.ParametersSerializationError})
            })
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {throw ServiceError.RequestFailed(description: error?.localizedDescription)})
                })
            
            } else if data == nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(response: {return nil})
                })
                
            } else {
                
                do {
                    let responseData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    let responseMessages = responseData as? [String:AnyObject]
                    if let messages = responseMessages?["Messages"] as? [[String : AnyObject]] {
                        if let message = messages.first {
                            let messageDescription = message["Description"] as? String
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(response: {throw ServiceError.ResponseErrorMessage(errorMessage: messageDescription)})
                            })
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(response: {return responseData})
                        })
                    }
                    
                } catch {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(response: {throw ServiceError.ResponseParsingError})
                    })
                }
            }
        }
        
        task.resume()

    }

}
