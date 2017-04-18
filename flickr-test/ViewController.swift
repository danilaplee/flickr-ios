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
    
    var screen_bounds:CGRect?
    
    func calcViewFrames(){
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //DEPENDENCY INJECTION
        app = AppController(v:self)
        nav = NavComponent(v: self, a: app!)
        col = CollectionComponent(v:self, a:app!)
        
        //INITIALIZE GENERAL PARAMS
        screen_bounds = UIScreen.main.bounds
        calcViewFrames()
        
        //INITIALIZE PRELOADER FOR APP TRANSITIONS
        view.addSubview(nav!.view)
        view.addSubview(col!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

