//
//  navComponent.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit
import Material

class SingleItemViewComponent: UIViewController {
    
    var app:AppController;
    var mainView:UIViewController;
    
    //GENERAL PARAMS
    var info:[String:Any] = [:]
    var provder:String = ""
    var img_url:String = ""
    var author:String = ""
    var title_text:String = ""
    
    //COMPONENT OPTIONS
    let image_compression = 0.9
    let button_square     = 40;
    let button_offset     = 10;
    let title_height      = 60;
    let line_height       = 30;
    let description_lines = 2;
    
    //VIEWS
    var image:UIImageView?
    var image_title:UILabel?
    var image_author:UILabel?
    var image_description:UILabel?
    var exitButton:UIButton?
    var linkButton:UIButton?
    
    //FRAMES
    var imageFrame:CGRect?
    var titleFrame:CGRect?
    var exitFrame:CGRect?
    var linkFrame:CGRect?
    
    //CENTERS
    var imageCenter:CGPoint?
    
    func closeComponent(){
        (mainView as! CollectionComponent).removeSingleItem(nil)
    }
    
    func nextImage(){
        (mainView as! CollectionComponent).incrementSingleItem(1)
    }
    func prevImage(){
        (mainView as! CollectionComponent).incrementSingleItem(-1)
    }
    func imageSwipe(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.right:
                    
//                    print("Swiped right")
                    self.prevImage()
                    
                break;
                    
                case UISwipeGestureRecognizerDirection.left:
                    
//                    print("Swiped left")
                    self.nextImage()
                    
                break;
                
                default:
                    print("other swipe")
                break;
            
            }
        }
    }
    
    func createViewFrames(){
        
        let component_view      = mainView.view!
        let width               = Int(component_view.frame.width)
        let height              = Int(component_view.frame.height)
        
        //IMAGE FRAME
        let image_offset_bottom = height/3
        let image_offset_top    = Int(Double(app.collection_inset_fix)*1.5)
        
        imageFrame      = CGRect(x:0,y:0, width:width, height:height-image_offset_bottom)
        imageCenter     = component_view.center as CGPoint
        imageCenter!.y  = imageCenter!.y - CGFloat(image_offset_bottom/2 + image_offset_top)
        
        //BUTTON FRAME
        exitFrame = CGRect(x:width-(button_offset+button_square),y:button_offset,width:button_square,height:button_square)
        
        //TITLE FRAME
        let title_offset_top = (Int((imageFrame?.height)!)-title_height)-button_offset
        titleFrame = CGRect(x:0,y:title_offset_top, width:width, height:title_height)
        
    }
    
    init(v:UIViewController, a:AppController, data:[String:Any]){
        //BIND DATA
        app = a;
        mainView = v;
        info = data;
        img_url = data["url"] as! String
        provder = data["provider"] as! String
        title_text = data["title"] as! String
        
        //RUN SUPER
        super.init(nibName: nil, bundle: nil)
        createViewFrames()
        
        //INIT VIEWS
        let component_view = v.view!
        
        //CREATE PASS THROUGHT BACKGROUND
        view.removeFromSuperview()
        view = nil;
        view = PassThroughView(frame:component_view.frame);
        view.center = component_view.center
        
        //IMAGE VIEW
        image = UIImageView(frame: imageFrame!)
        image!.center = imageCenter!
        
        image!.imageFromUrl(img_url, onload: { (path) in
            let data:Data       = NSData(contentsOfFile: path)! as Data
            let compress:Data   = UIImageJPEGRepresentation(UIImage(data: data)!, CGFloat(self.image_compression))!
            let preview:UIImage = UIImage(data:compress)!
            self.image?.image = preview
        })
        image!.contentMode = .scaleAspectFill
        image!.clipsToBounds = true
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.imageSwipe))
            rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.imageSwipe))
            leftSwipe.direction = .left
        
        image!.addGestureRecognizer(rightSwipe)
        image!.addGestureRecognizer(leftSwipe)
        image!.isUserInteractionEnabled = true;
        
//        image?.addGestureRecognizer(UISwipeGestureRecognizer)
//        image
        
        
        //EXIT BUTTON
        exitButton = UIButton(frame: exitFrame!)
        exitButton!.bounds = exitFrame!;
        exitButton!.setImage(Icon.close, for: .normal)
        exitButton!.isHidden = false;
        exitButton!.addTarget(self, action: #selector(self.closeComponent), for: .touchDown)
        
        
        //TITLE
        //        let gradient =
        let textFrame = CGRect(x:button_offset, y:button_offset, width:Int(titleFrame!.width)-button_offset*2, height:line_height)
        image_title = UILabel(frame: titleFrame!);
        image_title!.text = title_text;
        image_title!.bounds = textFrame
        image_title!.textRect(forBounds: textFrame, limitedToNumberOfLines: description_lines)
        image_title?.backgroundColor = UIColor.white;
        image_title?.opacity = 0.7;
        
        
        //INJECT VIEWS
        view.addSubview(image!)
        view.addSubview(exitButton!)
        view.addSubview(image_title!)
        view.bringSubview(toFront: image_title!)
        view.bringSubview(toFront: exitButton!)
        
//        print("INITIALIAZED SINGLE VIEW CONTROLLER")
//        print(exitButton)
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
