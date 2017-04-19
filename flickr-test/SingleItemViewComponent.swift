//
//  navComponent.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit

class SingleItemViewComponent: UIViewController {
    
    var app:AppController;
    var mainView:UIViewController;
    var info:[String:Any] = [:]
    
    //VIEWS
    
    
    init(v:UIViewController, a:AppController, data:[String:Any]){
        app = a;
        mainView = v;
        info = data;
        super.init(nibName: nil, bundle: nil)
        
        print("INITIALIAZED SINGLE VIEW CONTROLLER")
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
