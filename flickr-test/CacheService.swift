//
//  CacheService.swift
//  flickr-test
//
//  Created by Danila Puzikov on 18/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation

class CacheService {
    var app:AppController?
    var fileManager:FileManager;
    
    init(a:AppController) {
        app = a;
        fileManager = FileManager.default
    }
    
    func initCacheDirectory() {
        do {
            let documents   = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageDir    = documents.appendingPathComponent("images", isDirectory: true)
            if(fileManager.fileExists(atPath: imageDir.path))
            {
            clearImageCache()
            return;
            }
            try fileManager.createDirectory(atPath: imageDir.path, withIntermediateDirectories: false, attributes: [:])
            }
            catch(let error){
            print("INIT CACHE DIR ERROR")
            print(error)
        }
    }
    
    func clearImageCache(){
        do {
            let documents   = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageDir    = documents.appendingPathComponent("images", isDirectory: true)
            try fileManager.removeItem(at: imageDir)
            try fileManager.createDirectory(atPath: imageDir.path, withIntermediateDirectories: false, attributes: [:])
        }
        catch(let error){
            print("CACHE CLEARING ERROR")
            print(error)
        }
    }
}
