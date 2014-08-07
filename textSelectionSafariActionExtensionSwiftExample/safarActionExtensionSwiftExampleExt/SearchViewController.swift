//
//  SearchViewController.swift
//  textSelectionSafariActionExtensionSwiftExample
//
//  Created by Jaz Garewal on 8/7/14.
//  Copyright (c) 2014 Skinny Bones Productions. All rights reserved.
//

import UIKit
import MobileCoreServices

class SearchViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for item: AnyObject in self.extensionContext.inputItems! {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as NSString) {
                    weak var weakSearchTextField = self.searchTextField
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as NSString, options: nil, completionHandler: {(dictionary, error) in
                        if let resultsDictionary = dictionary as? NSDictionary {
                            let resultItem: NSDictionary! = resultsDictionary.objectForKey(NSExtensionJavaScriptPreprocessingResultsKey as NSString) as NSDictionary
                            let selectedText: String = resultItem.objectForKey("selectedText") as String
                            dispatch_async(dispatch_get_main_queue()) {
                                self.searchTextField.text = selectedText;
                            }
                        }
                    })
                }
            }
        }
        
        self.webView.delegate = self
        
    }
    

    @IBAction func searchButtonTapped(sender: AnyObject) {
        let searchTextString = searchTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlString = "http://wikipedia.org/search-redirect.php?family=wikipedia&search=\(searchTextString)&language=en"
        loadRequest(urlString)
    }
    
    func loadRequest(urlString:String) {
        var url = NSURL.URLWithString(urlString)
        dispatch_async(dispatch_get_main_queue()) {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
        
    }
    
    @IBAction func done() {
        self.extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

