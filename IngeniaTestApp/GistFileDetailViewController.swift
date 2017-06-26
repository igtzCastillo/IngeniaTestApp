//
//  GistFileDetailViewController.swift
//  IngeniaTestApp
//
//  Created by Alejandro Aristi C on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class GistFileDetailViewController: UIViewController, UIWebViewDelegate {
    
    private var fileURL: String! = ""
    
    private var mainWebView: UIWebView! = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(urlOfFile: String) {
        
        fileURL = urlOfFile
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        
        self.initInterface()
        
    }
    
    private func initInterface() {
        
        self.navigationController?.navigationBar.isHidden = false
        
        UtilityManager.sharedInstance.showLoader()
        
        self.initMainWebView()
        
    }
    
    private func initMainWebView() {
        
        mainWebView = UIWebView.init(frame: self.view.frame)
        mainWebView.delegate = self
        mainWebView.loadHTMLString(fileURL, baseURL: nil)
        
        let dragGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragGestureActivated(gestureRecognized:)))
        dragGesture.maximumNumberOfTouches = 1
        self.mainWebView.addGestureRecognizer(dragGesture)
        
        self.view.addSubview(mainWebView)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        UtilityManager.sharedInstance.hideLoader()
        
    }
    
    @objc private func dragGestureActivated(gestureRecognized: UIPanGestureRecognizer) {
        
        let vel = gestureRecognized.velocity(in: self.view)
        
        if vel.x > 0 {
            
            if self.mainWebView.canGoBack == true {
                
                self.mainWebView.goBack()
                
            } else {
                
                self.mainWebView.loadHTMLString(fileURL, baseURL: nil)
                
            }
            

            
        } else { //right
            
            self.mainWebView.goForward()
            
        }
        
    }
    
}
