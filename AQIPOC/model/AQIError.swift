//
//  AQIError.swift
//  SP Stock Quotes
//
//  Created by Pran Kishore on 29.09.20.
//  Copyright © 2020 Sample Solutions. All rights reserved.
//

import Foundation
/// This protocol defines the requirements for a single error case. Custom error classes should
/// use an enum to have multiple error cases in one class. That enum must then implement this
/// protocol.

public protocol AQIErrorCode {

    /// the error code (readonly)

    var code: Int {get}

    /// the error domain (readonly)
    var domain: String {get}

    /// The error's localized description. Note that this is the fully resolved string, not just the key

    /// This is because resolving the string down in SPError would not work, when the error strings are

    /// defined the strings files of their own module/product. (readonly)

    var localizedMessage: String {get}

    /// The error's localized title (optional, readonly)
    var localizedTitle: String? {get}

}

/// Represents a custom app-generated error. This class is an abstract NSError wrapper. Concrete errors should be

/// Implemented as subclasses of this class. The various error cases can be added through an enum that implements

/// AQIErrorCode.

open class AQIError: NSError {

    /// The error code is an object that must implement SPErrorCode
    /// Should be an enum but can be anything else as well!
    public var errorCode: AQIErrorCode

    open var localizedMessage: String {
        return errorCode.localizedMessage
    }

    open var localizedTitle: String? {
        return errorCode.localizedTitle
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    /// Creates an error instance using the given AQIErrorCode.

    public init(errorCode: AQIErrorCode) {
        self.errorCode = errorCode
        super.init(domain: errorCode.domain, code: errorCode.code, userInfo: nil)

    }

}

class AQIServiceError: AQIError {

    enum ErrorCode: Int, AQIErrorCode {

        case unknownError
        case connectionError
        case requestTimeOut
        case noNetwork

        var code: Int {
            return rawValue
        }
        var domain: String {
            return "WebService"
        }

        var localizedMessage: String {
            switch self {
            case .unknownError:
                return "Unknown error. Please try again later."
            case .connectionError:
                return "Could not connect to server. Please try again later."
            case .noNetwork:
                return "Not connected to internet. Please check your connection"
            case .requestTimeOut:
                return "Request Timed out"
            }

        }
        var localizedTitle: String? {
            return "Stock Quotes"
        }

    }

    static func customError(for error: NSError) -> ErrorCode {
        switch error.code {
        case -1009:
            return .noNetwork
        case -1001:
            return .requestTimeOut
        case -1008...(-1002):
            return .connectionError
        default:
            return .unknownError
        }
    }

    public convenience init(error: NSError) {
        let item = AQIServiceError.customError(for: error)
        self.init(errorCode: item)
    }
}

class AQIServerResponseError: AQIError {

    static let JsonParsing = AQIServerResponseError.init(errorCode: ErrorCode.jsonParsingError)
    static let Unknown = AQIServerResponseError.init(errorCode: ErrorCode.unknownError)

    enum ErrorCode: AQIErrorCode {

        case jsonParsingError
        case serverErrorMessage(String)
        case unknownError
        case payment

        var code: Int {
            return 0
        }
        var domain: String {
            return "ServerResponse"
        }

        var localizedMessage: String {
            switch self {
            case .serverErrorMessage(let message):
                return message
            default:
                return "Internal error. Please try again later."
            }

        }
        var localizedTitle: String? {
            return "Stock Quotes"
        }

    }

    public convenience init(error: String) {
        let item = ErrorCode.serverErrorMessage(error)
        self.init(errorCode: item)
    }
}
