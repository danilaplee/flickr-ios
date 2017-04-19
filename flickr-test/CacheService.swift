//
//  CacheService.swift
//  flickr-test
//
//  Created by Danila Puzikov on 18/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit

class CacheService {
    var app:AppController?
    var fileManager:FileManager;
    var images:[String:Any] = [:]
    public typealias CompletionHandler = (_ success:[String:Any]) -> Void
    
    init(a:AppController) {
        app = a;
        fileManager = FileManager.default
    }
    
    func memorizeImage(_ key:String, _ path:String?) -> UIImage {
        if(images[key] != nil) { return images[key] as! UIImage }
        if(path == nil) { return UIImage(); }
        let data:Data       = NSData(contentsOfFile: path!)! as Data
        let compress:Data   = UIImageJPEGRepresentation(UIImage(data: data)!, 0.1)!
        let preview:UIImage = UIImage(data:compress)!
        return preview;
        
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
    
    func cacheCollection(images:[[String:Any]], done:@escaping CompletionHandler){
        let qu = app?.view?.col?.prev_query as! String;
        
        let queue = DispatchQueue.global()
        queue.async() {
            var is_done   = false;
            var show_time = images.count as Int
            for(index, item) in images.enumerated() {
                var i   = item
                let url = item["url"]
                let imageView = UIImageView()
                imageView.imageFromUrl(url as! String, onload: { (response) in
                    if(qu != self.app?.view?.col?.prev_query) { return }
                    if(response == "false" || response == "true"){
                        show_time = show_time - 1
                        return;
                    }
                    let key = response.md5()
                    i["cache_key"] = key
                    self.app?.view?.col?.images[index] = i
                    self.images[key] = self.memorizeImage(key, response)
                    print("CACHE STATUS: "+self.images.count.description+"/"+show_time.description)
                    if(self.images.count >= show_time && is_done == false) {
                        is_done = true;
                        print("collection cache done")
                        DispatchQueue.main.async(execute: {
                            done(self.images)
                        });
                    }
                });
                
            }
        }
    }
    
    func clearImageCache(){
        do {
            images = [:]
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
