//
//  String+Slice.swift
//  PwnedPasswords
//
//  Created by Christoffer Buusmann on 28/03/2018.
//

import Foundation
extension String {
  func slice(from: Int) -> String {
    return String(self[createIndex(offset: from)...])
  }
  
  func slice(to: Int) -> String {
    return String(self[..<createIndex(offset: to)])
  }
  
  private func createIndex(offset: Int) -> String.Index {
    return self.index(self.startIndex, offsetBy: offset)
  }
}
