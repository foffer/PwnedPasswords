//
//  ApiClient.swift
//  CryptoSwift
//
//  Created by Christoffer Buusmann on 28/03/2018.
//

import Foundation

internal enum ApiError: Error {
  case noData
  case parseURL
}

internal protocol Api {
  func getResponse(forPrefix prefix: String, completion: @escaping (String, Error?) -> Void)
}

internal class ApiClient: Api {
  let endpoint = "https://api.pwnedpasswords.com/range"
  
  internal func getResponse(forPrefix prefix: String, completion: @escaping (String, Error?) -> Void) {
    guard let url = URL(string: "\(endpoint)/\(prefix)") else {
      completion("", ApiError.parseURL)
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, res, error in
      guard error == nil else {
        completion("", error)
        return
      }
      if let data = data, let string = String(bytes: data, encoding: String.Encoding.ascii) {
        completion(string, nil)
      } else {
        completion("", ApiError.noData)
      }
    }
    task.resume()
  }
}
