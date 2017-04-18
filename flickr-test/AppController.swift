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
    var cache:CacheService?
    var history:[String] = [];
    var search_cache:[[String:Any]] = []
    var fileManager:FileManager?
    var current_page = 0;
    
    //CONSTANTS
    let nav_height = 65;
    let welcome_text = "Welcome to Image Search";
    
    init(v:ViewController)
    {
        view        = v;
        api         = ApiService(a:self);
        cache       = CacheService(a:self);
        fileManager = FileManager.default
        initCacheDirectory()
    }
    
    func initCacheDirectory() {
        cache?.initCacheDirectory()
    }
    
    func searchFullText(_ string:String)
    {
        api?.searchFullText(string, current_page, done: { (data) in
            if(self.current_page == 1) {
                self.search_cache = data
            }
            else { self.search_cache += data }
            self.displaySearchResult(self.search_cache)
        })
    }
    
    func displayLoading(){
        view!.col!.showLoader(api!.current_query)
    }
    
    func displaySearchResult(_ result:[[String:Any]])
    {
        print("===== displaying search result =====")
        view!.col!.displayCollection(result)
    }
    
    func clearImageCache(){
        cache?.clearImageCache()
    }
    
}
