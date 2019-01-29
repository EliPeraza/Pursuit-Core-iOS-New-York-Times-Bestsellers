//
//  FileManagerHelper.swift
//  NYTBestsellers
//
//  Created by Elizabeth Peraza  on 1/29/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

final class FinalManagerHelper {
  
  static let filename = "FavoriteBookList.plist"
  private static var bookItems = [FavoriteBooks]()
  
  private init() {}
  
  static func saveFavoriteBooks() {
    let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
    print("I have a path: \(path)")
    
    do{
      let data = try PropertyListEncoder().encode(bookItems)
      try data.write(to: path, options: Data.WritingOptions.atomic)
    } catch {
      print("property list encoding error: \(error)")
    }
  }
  
  static func getFavoriteBooksInfo() -> [FavoriteBooks] {
    
    let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
    
    if FileManager.default.fileExists(atPath: path) {
      if let data = FileManager.default.contents(atPath: path) {
        do {
          bookItems = try PropertyListDecoder().decode([FavoriteBooks].self, from: data)
        } catch {
          print("property list decoding error: \(error)")
        }
      } else {
        print("getFavoriteBooksInfo data: is nil")
      }
    } else {
      print("\(filename) does not exist")
    }
    bookItems = bookItems.sorted {$0.date > $1.date}
    return bookItems
  }
  
  static func addEntry(book: FavoriteBooks) {
    bookItems.append(book)
    saveFavoriteBooks()
  }
  
  static func delete(atIndex index: Int) {
   bookItems.remove(at: index)
    saveFavoriteBooks()
  }
  
}
