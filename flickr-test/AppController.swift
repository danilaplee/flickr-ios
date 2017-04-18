//
//  AppService.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation

class AppController {
    
    var view:ViewController?
    var api:ApiService?
    var history:[String] = [];
    var search_result:[[String:Any]] = []
    var fileManager:FileManager?
    
    //CONSTANTS
    let nav_height = 65;
    let welcome_text = "Welcome to Image Search";
    
    init(v:ViewController)
    {
        view        = v;
        api         = ApiService(a:self);
        fileManager = FileManager.default
        initCacheDirectory()
    }
    
    func initCacheDirectory() {
        
        do {
            let documents   = try fileManager!.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageDir    = documents.appendingPathComponent("images", isDirectory: true)
            if(fileManager!.fileExists(atPath: imageDir.path))
            {
                clearImageCache()
                return;
            }
            try fileManager!.createDirectory(atPath: imageDir.path, withIntermediateDirectories: false, attributes: [:])
        }
        catch(let error){
            print("INIT CACHE DIR ERROR")
            print(error)
        }

    }
    
    func displaySearchResult(_ result:[[String:Any]])
    {
        print("===== displaying search result =====")
        view!.col!.displayCollection(result)
    }
    
    func hideCollectionView(){
        view!.col!.view.isHidden = true;
    }
    
    func clearImageCache(){
        do {
            let documents   = try fileManager!.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageDir    = documents.appendingPathComponent("images", isDirectory: true)
            try fileManager?.removeItem(at: imageDir)
            try fileManager!.createDirectory(atPath: imageDir.path, withIntermediateDirectories: false, attributes: [:])
        }
        catch(let error){
            print("CACHE CLEARING ERROR")
            print(error)
        }
        
    }
    
}
