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
    
    //BUILDING MAIN VIEW ITEMS
    var loader:UIActivityIndicatorView?
    var welcome_text:UILabel?
    
    //GENERAL PARAMS
    var screen_bounds:CGRect?
    
    //VIEW FRAMES
    var h1_frame:CGRect?;
    var h1_frame_center:CGPoint?;
    let minimal_sqr = CGRect(x:0,y:0,width:20, height:20);
    
    func calcViewFrames(){
        //INITIALIZE WELCOME TEXT
        let h1_padding = 40;
        h1_frame = CGRect(x:0,y:0,width:Int(screen_bounds!.width)-h1_padding, height:30)
        h1_frame_center = view.center;
        h1_frame_center!.y = h1_frame_center!.y + minimal_sqr.height*2
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
        loader = UIActivityIndicatorView(frame: minimal_sqr)
        loader?.center = view.center
        loader?.isHidden = false;
        loader?.activityIndicatorViewStyle = .gray
        loader?.startAnimating();
        
        welcome_text =  UILabel(frame: h1_frame!)
        welcome_text!.center = h1_frame_center!;
        welcome_text!.text = "WELCOME TO IMAGE SEARCH"
        welcome_text!.isHidden = false;
        welcome_text!.textAlignment = .center
        
        //INJECTING VIEWS
        view.addSubview(loader!)
        view.addSubview(welcome_text!)
        view.addSubview(nav!.view)
//        view.addSubview(col!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

