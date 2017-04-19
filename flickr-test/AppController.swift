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
    var single_item_id:String?
    var search_cache:[[String:Any]] = []
    var fileManager:FileManager?
    var current_page = 0;
    
    //CONSTANTS
    let collection_inset_fix = 29;
    let min_loaded_images = 1.0;
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
        let prev_size = search_cache.count
        api?.searchFullText(string, current_page, done: { (data) in
            if(self.current_page == 1) {
                self.search_cache = data
            }
            else { self.search_cache += data }
            if(self.search_cache.count == prev_size) {
                self.view?.col?.loader?.hide()
                return
            }
            self.displaySearchResult(self.search_cache)
        })
    }
    func incrementPage(){
        DispatchQueue.main.async(execute: {
            self.current_page += 1
            self.searchFullText(self.api!.current_query)
            let collection:CollectionComponent = self.view!.col!
            collection.loader?.show()
            collection.loader?.view.isHidden = false;
            collection.view.bringSubview(toFront: collection.loader!.view)
        });
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
