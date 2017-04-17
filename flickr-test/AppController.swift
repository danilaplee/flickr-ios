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
    
    init(v:ViewController)
    {
        view = v;
        api = ApiService(a:self);
    }
    
}
