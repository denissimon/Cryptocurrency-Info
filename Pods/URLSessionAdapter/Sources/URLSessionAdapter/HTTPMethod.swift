//
//  HTTPMethod.swift
//  https://github.com/denissimon/URLSessionAdapter
//
//  Created by Denis Simon on 19/12/2020.
//
//  MIT License (https://github.com/denissimon/URLSessionAdapter/blob/main/LICENSE)
//

/// https://datatracker.ietf.org/doc/html/rfc7231#section-4.3
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
    case OPTIONS
    case CONNECT
    case TRACE
    case QUERY /// https://www.ietf.org/archive/id/draft-ietf-httpbis-safe-method-w-body-02.html
}
