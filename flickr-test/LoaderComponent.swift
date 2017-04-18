//
//  navComponent.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit

class LoaderComponent: UIViewController {
    
    var app:AppController?
    var mainView:UIViewController?
    
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
        let h1_padding = 40;
        h1_frame = CGRect(x:0,y:0,width:Int(screen_bounds!.width)-h1_padding, height:30)
        h1_frame_center = view.center;
        h1_frame_center!.y = h1_frame_center!.y + minimal_sqr.height*2
    }
    
    func setText(_ text:String){
        welcome_text?.text = text;
        welcome_text?.isHidden = false;
        
    }
    func show(){
        loader?.isHidden = false;
        view.isHidden = false;
    }
    func hide(){
        loader?.isHidden = true;
        welcome_text?.isHidden = true;
        view.isHidden = true;
    }
    
    init(v:UIViewController, a:AppController){
        mainView = v;
        app = a;
        super.init(nibName: nil, bundle: nil)
        screen_bounds = UIScreen.main.bounds
        calcViewFrames()
        
        loader = UIActivityIndicatorView(frame: minimal_sqr)
        loader?.center = view.center
        loader?.activityIndicatorViewStyle = .gray
        loader?.startAnimating();
        welcome_text =  UILabel(frame: h1_frame!)
        welcome_text!.center = h1_frame_center!;
        welcome_text!.text = app!.welcome_text
        welcome_text!.isHidden = false;
        welcome_text!.textAlignment = .center
        
        //INJECTING VIEWS
        view.addSubview(loader!)
        view.addSubview(welcome_text!)
        loader?.isHidden = true;
        
        print("INITIALIAZED LOADER COMPONENT")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
