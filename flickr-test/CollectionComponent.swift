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
    var cache:CacheService;
    var mainView:UIViewController;
    public typealias CompletionHandler = (_ success:[String:Any]) -> Void
    
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
    var current_scroll:CGPoint?;
    
    
    init(v:UIViewController, a:AppController){
        app = a;
        cache = a.cache!;
        mainView = v;
        nav_height = a.nav_height;
        
        super.init(nibName: nil, bundle: nil)
        view.frame = CGRect(x:0,y:nav_height-29,width:Int(v.view.frame.width), height:Int(v.view.frame.height)-nav_height)
        loader = LoaderComponent(v:self, a:a)
        initCollectionView()
        view.addSubview(loader!.view)
        print("INITIALIAZED SINGLE VIEW CONTROLLER")
    }
    
    func initCollectionView(){
        DispatchQueue.main.async(execute: {
            let layout = UICollectionViewFlowLayout()
            if(self.collectionView != nil){
                print("reloading collection view!")
                self.current_scroll = self.collectionView!.contentOffset
                self.collectionView?.reloadData()
            }
            else {
                print("creating collection view!")
                self.collectionView = UICollectionView(frame:self.view.frame, collectionViewLayout: layout);
                self.collectionView!.register(ImagePreview.self, forCellWithReuseIdentifier: "imgCell")
                self.collectionView!.backgroundColor = UIColor.clear
                self.collectionView!.delegate = self
                self.collectionView!.dataSource = self
                self.view.isHidden = true;
                self.view.addSubview(self.collectionView!)
                self.collectionView?.reloadData()
            }
            if(self.app.current_page != 1 && self.current_scroll != nil) {
                self.collectionView?.contentOffset = self.current_scroll!
            }
            self.loader?.hide()
            self.loader?.view.isHidden = true;
            self.view.isHidden = false;
//            self.view.bringSubview(toFront: self.loader!.view)
        });
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
        if(prev_query != query) {
            self.cache.images = [:]
            collectionView?.isHidden = true;
        }
        else {
            return;
        }
        prev_query = query;
        loader?.setText("Loading "+query+"... ")
        loader?.show()
        loader?.view.isHidden = false;
    }
    func cacheCollection(done:@escaping CompletionHandler){
        cache.cacheCollection(images: self.images) { (image_cache) in
            done(image_cache)
        }
    }
    
    func displayCollection(_ data:[[String:Any]]){
        print("LOADING COLLECTION")
        print("TOTAL COUNT = "+data.count.description)
        self.images = data
        self.total_loaded = 0;
        self.total_displayed = 0;
        cacheCollection { (_) in
            print("EVERYTHING CACHED")
            print("TOTAL CACHED = "+self.cache.images.count.description)
            if(self.app.current_page == 1) {
                DispatchQueue.main.async(execute: {
                    print("removed collection view!")
                    self.collectionView?.removeFromSuperview()
                    self.collectionView = nil
                });
            }
            self.initCollectionView()
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = images[indexPath.row]
        let url = data["url"]
        let qu = prev_query
        var key = data["cache_key"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ImagePreview
        cell.awakeFromNib()
        if(key != nil) {
            self.total_loaded += 1;
            let img = self.cache.memorizeImage(key as! String, nil)
            DispatchQueue.main.async(execute: {
                cell.imageView?.image = img
                if(self.loader!.view.isHidden == false
                    && self.total_loaded == Int(Double(self.images.count)/self.app.min_loaded_images)) {
                        print("hiding preloader")
                        self.loader?.hide()
                }
            });
            print("IMAGE FROM CACHE KEY")
            print(key)
            return cell;
        }
        cell.imageView?.imageFromUrl(url as! String, onload: { (response) in
            self.view.isHidden = false;
            self.total_loaded += 1;
            if(response == "false" || response == "true"){ return; }
            
            let key = response.md5()
            let page = self.app.current_page
            let img = self.cache.memorizeImage(key, response)

            DispatchQueue.main.async(execute: {
                print("IMAGE FROM FILE CHECK")
                cell.imageView?.image = img
            });
                
            if(self.loader!.view.isHidden == false && self.total_loaded == Int(Double(self.images.count)/self.app.min_loaded_images)) {
                DispatchQueue.main.async(execute: {
                    print("hiding preloader")
                    self.loader?.hide()
//                    self.collectionView?.reloadData()
                });
            }
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        total_displayed += 1;
        if(indexPath.row == Int(Double(self.images.count)/1.1)) {
            DispatchQueue.main.async(execute: {
                self.app.current_page += 1
                self.app.searchFullText(self.prev_query)
                self.loader?.show()
                self.loader?.view.isHidden = false;
                self.view.bringSubview(toFront: self.loader!.view)
            });
        }
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
