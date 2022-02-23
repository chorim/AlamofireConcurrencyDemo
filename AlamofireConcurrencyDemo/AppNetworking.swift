//
//  AppNetworking.swift
//  AlamofireConcurrencyDemo
//
//  Created by Insu Byeon on 2022/02/24.
//

import Foundation
import Alamofire

final class AppNetworking {
  static let shared = AppNetworking()
  
  private init() { }
  
  private let session: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    return Session(configuration: configuration)
  }()
  
  func requestJSON<T: Decodable>(_ url: String,
                                 type: T.Type,
                                 method: HTTPMethod,
                                 parameters: Parameters? = nil) async throws -> T {
    
    return try await session.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: URLEncoding.default)
      .serializingDecodable()
      .value
  }
}


