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
    
    var mainView:UIViewController;
    
    //BUILDING MAIN VIEW ITEMS
    var loader:UIActivityIndicatorView?
    var welcome_text:UILabel?
    
    //GENERAL PARAMS
    var screen_bounds:CGRect?
    
    //VIEW FRAMES
    var h1_frame:CGRect?;
    var h1_frame_center:CGPoint?;
    let minimal_sqr = CGRect(x:0,y:0,width:20, height:20);
    
    init(v:UIViewController){
        mainView = v;
        super.init(nibName: nil, bundle: nil)
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
