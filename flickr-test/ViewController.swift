//
//  ViewController.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //DEPENDENCY INJECTION
    var app:AppController?
    var nav:NavComponent?
    var col:CollectionComponent?
    var singleView:SingleItemViewComponent?
    
    //BUILDING SHARED VIEW ITEMS
    var loader:UIProgressView?
    
    //GENERAL PARAMS
    var screen_bounds:CGRect?
    
    //RANDOM ABSTRACTS
    let minimal_sqr = CGRect(x:0,y:0,width:20, height:20);
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //DEPENDENCY INJECTION
        app = AppController(v:self)
        nav = NavComponent(v: self, a: app!)
        col = CollectionComponent(v:self, a:app!)
        
        //INITIALIZE GENERAL PARAMS
        screen_bounds = UIScreen.main.bounds
        
        //INITIALIZE PRELOADER FOR APP TRANSITIONS
        loader = UIProgressView(frame: minimal_sqr)
        loader?.center = view.center
        loader?.isHidden = false;
        view.addSubview(loader!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

