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
    
    //FLICKR PARAMS
    var flickr_auth_token           = "";
    var flickr_frob_token           = "";
    let flickr_secret               = "36f8f9a077f5932a"
    let flickr_api_key              = "8f154e3591322b1e0e1f8a1294aa79c6"
    let flickr_api                  = "https://api.flickr.com/services/rest/?"
    let flickr_search_params          = "method=flickr.photos.search&api_key=[api_key]&text=[text]&format=json&nojsoncallback=1"
    let flickr_frob_params          = "api_key=[api_key]&method=flickr.auth.getFrob";
    let flickr_auth_params          = "api_key=[api_key]&frob=[frob]&method=flickr.auth.getToken";
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
    func genFlickrSig(_ string:String) -> String {
         return "&api_sig="+(flickr_secret+string.replace("=", "").replace("&", "")).md5()
    }
    func authFlicker(){
        var frob_params  = flickr_frob_params.replace("[api_key]", flickr_api_key)
            frob_params += genFlickrSig(frob_params)
        let frob_link = flickr_api+frob_params
        flickr_frob_token = syncHttpCall(url: frob_link)
        if(flickr_frob_token == "failed") {
            print("frob failed")
            return
        }
        
        flickr_frob_token = (flickr_frob_token.components(separatedBy: "<frob>")[1]).components(separatedBy: "</frob>")[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var auth_params  = flickr_auth_params.replace("[api_key]", flickr_api_key).replace("[frob]", flickr_frob_token)
            auth_params += genFlickrSig(auth_params)
        
        flickr_auth_token = syncHttpCall(url: flickr_api+auth_params)
    }
    
    func genFlickrImgUrl(photo:[String:Any]) -> String {
        print(photo)
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
    
    func searchGoogle(string:String, page:Int) -> [[String:Any]]{
        return [];
    }
    
    func searchFullText(_ string:String, _ page:Int) {
        print("searching for "+string)
        current_query = string;
        app!.displayLoading()
        let flickr_data = searchFlickr(string: string, page: page)
        let google_data = searchGoogle(string: string, page: page)
        let data = flickr_data + google_data
        print("total search result "+data.description)
        app!.displaySearchResult(data)
    }
}
