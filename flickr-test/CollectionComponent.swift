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
    
    
    init(v:UIViewController, a:AppController){
        app = a;
        mainView = v;
        nav_height = a.nav_height;
        
        super.init(nibName: nil, bundle: nil)
        
        view.frame = CGRect(x:0,y:nav_height-20,width:Int(v.view.frame.width), height:Int(v.view.frame.height)-nav_height)
        initCollectionView()
        print("INITIALIAZED SINGLE VIEW CONTROLLER")
    }
    
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        collectionView?.removeFromSuperview()
        collectionView = nil
        collectionView = UICollectionView(frame:view.frame, collectionViewLayout: layout);
        collectionView!.register(ImagePreview.self, forCellWithReuseIdentifier: "imgCell")
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.delegate = self
        collectionView!.dataSource = self
        view.addSubview(collectionView!)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ImagePreview
            cell.awakeFromNib()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let url = images[indexPath.row]["url"]
        let img = (cell as! ImagePreview)
        img.imageView?.imageFromUrl(url as! String, onload: { (response) in
            self.view.isHidden = false;
        })
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
