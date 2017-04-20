//
//  ViewController.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import UIKit
import EasyTipView

class ViewController: UIViewController, EasyTipViewDelegate {
    

    
    //DEPENDENCY INJECTION
    var app:AppController?
    var nav:NavComponent?
    var col:CollectionComponent?
    var singleView:SingleItemViewComponent?
    var tipViews:[EasyTipView] = []
    var is_hiding_tips = false;
    var tipTimer:Timer?
    public typealias CompletionHandler = (_ success:String) -> Void
    
    var screen_bounds:CGRect?
    
    func calcViewFrames(){
        
    }
    
    func dismissTips(done:@escaping CompletionHandler){
        print("removing tip views")
        if(tipViews.count == 0) {
            done("")
            return;
        }
        self.is_hiding_tips = true;
        let total = tipViews.count
        var dismissed = 0;
        DispatchQueue.main.async() {
            for(i, item) in self.tipViews.enumerated() {
                item.dismiss(withCompletion: {
                    dismissed += 1;
                    if(dismissed == total){
                        self.tipViews = [];
                        self.is_hiding_tips = false;
                        done("")
                    }
                })
            }
        }
        
    }
    func runNews(){
        print("creating news")
        dismissTips { (s) in
            self.makeTip("Popular on PetaCat:")
            self.makeTip("#funny cats")
            self.makeTip("#longcat")
            self.makeTip("#Lolcats")
        }
            
    }
    
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        let txt = tipView.text
        print("dismissed tip view "+txt)
        if(is_hiding_tips == true) { return }
        if(txt[0] == "#") {
            let query = txt.replace("#", "")
            self.dismissTips(done: { (s) in })
            DispatchQueue.main.async() {
                print("clicked search tag == "+txt)
                self.nav?.search?.text = query
                self.nav?.startSearch()
            }
            return
        }
    }
    
    func makeTip(_ text:String){
        var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont(name: "Futura", size: 13)!
            preferences.drawing.foregroundColor = .white
            preferences.drawing.backgroundColor = app!.pink
            preferences.drawing.arrowPosition = .top
        let tipView = EasyTipView(text: text, preferences: preferences, delegate: self)
        if(tipViews.count == 0) {
            tipView.show(animated: true, forView: (nav!.view)!, withinSuperview: view)
            tipViews.append(tipView)
        }
        else {
            tipView.show(animated: true, forView: tipViews.last!, withinSuperview: view)
            tipViews.append(tipView)
        }
    }
    
    func hideCollection(){
        UIView.animate(withDuration: 0.5, animations: {
            self.col?.collectionView?.center.y = (self.col?.collectionView?.center.y)!*3
        }) { (state) in
            self.col?.collectionView?.removeFromSuperview()
            self.col?.collectionView = nil;
            self.col?.view.isHidden = true;
            self.app?.clearImageCache()
            self.runNews()
        }
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
        view.bringSubview(toFront: nav!.view)
        runNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

