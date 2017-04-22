//
//  ApiService.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import CryptoSwift

class ApiService {
    var app:AppController?
    var current_query = "";
    var per_page      = 10;
    public typealias CompletionHandler = (_ success:[[String:Any]]) -> Void
    
    //FLICKR PARAMS
    var flickr_auth_token           = "";
    var flickr_frob_token           = "";
    let flickr_api_key              = "8f154e3591322b1e0e1f8a1294aa79c6"
    let flickr_api                  = "https://api.flickr.com/services/rest/?"
    let flickr_search_params          = "method=flickr.photos.search&api_key=[api_key]&page=[page]&per_page=[per_page]&text=[text]&format=json&nojsoncallback=1&safe_seach=1"
    let flickr_frob_params          = "api_key=[api_key]&method=flickr.auth.getFrob";
    let flickr_auth_params          = "api_key=[api_key]&frob=[frob]&method=flickr.auth.getToken";
    
    //INSTAGRAM PARAMS
    var ig_auth_token = ""
    let ig_client_id  = "bc892a6747be45549f0cce0662dc91ed"
    let ig_api_url    = "https://api.instagram.com/v1/"
    let ig_auth_url   = "https://www.instagram.com/oauth/authorize/"
    let ig_auth_param = "?client_id=[client_id]&redirect_uri=http://localhost/&response_type=token&scope=public_content"
    let ig_srch_tags  = "tags/search?q=cat&access_token=[auth_token]"
    
    init(a:AppController) {
        app = a;
    }
    
    func syncHttpCall(url:String) -> String {
        do {
            let call:String = try String(contentsOf: URL(string:url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
            return call;
        }
        catch(let error) {
            print(error)
            return "failed";
        }
    }
    
    func genFlickrImgUrl(photo:[String:Any]) -> String {
        let farm    = (photo["farm"] as! Int).description
        let server  = photo["server"] as! String
        let id      = photo["id"] as! String
        let secret  = photo["secret"] as! String
        
        return "https://farm"+farm+".staticflickr.com/"+server+"/"+id+"_"+secret+".jpg"
    }
    
    func searchFlickr(string:String, page:Int) -> [[String:Any]]{
        
        let flickr_params:String = flickr_search_params
            .replace("[text]", string)
            .replace("[page]", page.description)
            .replace("[api_key]", flickr_api_key)
            .replace("[per_page]", per_page.description)
        
        let new_flickr_call = flickr_api+flickr_params
        let res             = syncHttpCall(url: new_flickr_call)
        
        if(res != "failed") {
            do {
                let _data               = res.data(using: .utf8)
                let _res:[String:Any]   = try JSONSerialization.jsonObject(with: _data!, options: .mutableContainers) as! [String:Any]
                
                let _obj:[String:Any]       = _res["photos"] as! [String:Any]
                let _array:[[String:Any]]   = _obj["photo"] as! [[String:Any]]
                var parsed:[[String:Any]]   = []
                for(_, item) in _array.enumerated() {
                    var i:[String:Any] = item;
                    i["url"] = genFlickrImgUrl(photo: i)
                    i["provider"] = "flickr"
                    parsed.append(i)
                }
                print("flickr total found "+_array.count.description+" photos")
                return parsed;
            }
            catch(let error){
                print("Seriliazation error")
                print(error)
            }
        }
        return []
    }
    
    func findHotTags(done:@escaping CompletionHandler) {
        
    }
    
    func searchInstagram(string:String, page:Int) -> [[String:Any]]{
        return [];
    }
    
    func searchFullText(_ string:String, _ page:Int, done:@escaping CompletionHandler) {
        print("searching for "+string)
        current_query = string;
        app!.displayLoading()
        let queue = DispatchQueue.global()
        queue.async() {
            let flickr_data = self.searchFlickr(string: string, page: page)
            let google_data = self.searchInstagram(string: string, page: page)
            let data = flickr_data + google_data
            print("total search result "+data.description)
            DispatchQueue.main.async() {
                done(data)
            };
        };
    }
}
