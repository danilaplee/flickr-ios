//
//  ApiService.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation

class ApiService {
    var app:AppController?;
    
    init(a:AppController) {
        app = a;
    }
    
    func httpCall() {
        
    }
    
    func searchFullText(s:String) {
        print("searching for "+s)
        
    }
}
