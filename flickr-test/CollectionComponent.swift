//
//  navComponent.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit

class CollectionComponent: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var app:AppController;
    var mainView:UIViewController;
    
    //VIEWS
    
    var loader:LoaderComponent?;
    var collectionView:UICollectionView?;
    
    //GENERAL PARAMS;
    
    var nav_height = 0;
    var images:[[String:Any]] = []
    var imageCache:[String:Any] = [:]
    var total_loaded = 0;
    var total_displayed = 0;
    var prev_query = ""
    
    
    init(v:UIViewController, a:AppController){
        app = a;
        mainView = v;
        nav_height = a.nav_height;
        
        super.init(nibName: nil, bundle: nil)
        view.frame = CGRect(x:0,y:nav_height-29,width:Int(v.view.frame.width), height:Int(v.view.frame.height)-nav_height)
        loader = LoaderComponent(v:self, a:a)
        view.addSubview(loader!.view)
        initCollectionView()
        print("INITIALIAZED SINGLE VIEW CONTROLLER")
    }
    
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        collectionView?.removeFromSuperview()
        total_loaded = 0;
        total_displayed = 0;
        collectionView = nil
        collectionView = UICollectionView(frame:view.frame, collectionViewLayout: layout);
        collectionView!.register(ImagePreview.self, forCellWithReuseIdentifier: "imgCell")
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.delegate = self
        collectionView!.dataSource = self
        view.isHidden = false;
        view.addSubview(collectionView!)
        view.bringSubview(toFront: loader!.view)
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
    func showLoader(_ query:String){
        if(prev_query != query) { imageCache = [:] }
        prev_query = query;
        loader?.setText("Loading "+query+"... ")
        loader?.show()
    }
    
    func displayCollection(_ data:[[String:Any]]){
        images = data;
        initCollectionView()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = images[indexPath.row]["url"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ImagePreview
        cell.awakeFromNib()
        cell.imageView?.imageFromUrl(url as! String, onload: { (response) in
            self.view.isHidden = false;
            self.total_loaded += 1;
            if(response == "false" && response == "true"){
                return;
            }
            if(self.imageCache[response.md5()] == nil)
            {
                self.imageCache[response.md5()] = UIImage(contentsOfFile: response)
            }
            cell.imageView?.image = self.imageCache[response.md5()] as! UIImage
            if(self.loader!.view.isHidden == false && self.total_loaded == self.total_displayed) {
                DispatchQueue.main.async(execute: {
                    print("hiding preloader")
                    self.loader?.hide()
                    self.collectionView?.reloadData()
                });
            }
        })
        total_displayed += 1;
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
}

class ImagePreview:UICollectionViewCell {
    var imageView:UIImageView?;
    override func awakeFromNib() {
        imageView = UIImageView(frame:contentView.frame)
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        contentView.addSubview(imageView!)
    }
    
}
