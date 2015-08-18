//
//  iEMIService.swift
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
}

protocol Service: NSObjectProtocol {

    var baseURL: String { get }

    func get(url: String, parameters: Dictionary<String, String>, completion: (response: () throws -> AnyObject?) -> Void) -> Void
    
    func post(url: String, parameters: Dictionary<String, String>, completion: (response: () throws -> AnyObject?) -> Void) -> Void

}
