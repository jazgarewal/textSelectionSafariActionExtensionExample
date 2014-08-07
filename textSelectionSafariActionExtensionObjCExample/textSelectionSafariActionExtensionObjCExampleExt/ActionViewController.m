//
//  ActionViewController.m
//  textSelectionSafariActionExtensionObjCExampleExt
//
//  Created by Jaz Garewal on 8/7/14.
//  Copyright (c) 2014 Skinny Bones Productions. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *item, NSUInteger idx, BOOL *stop) {
        [item.attachments enumerateObjectsUsingBlock:^(NSItemProvider *itemProvider, NSUInteger idx, BOOL *stop) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                    NSDictionary *results = (NSDictionary *)dictionary;
                    NSString *selectedText = [[results objectForKey:NSExtensionJavaScriptPreprocessingResultsKey] objectForKey:@"selectedText"];
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self setupSearchTextField:selectedText];
                        
                    });
                }];
            }
        }];
        
    }];
    
    self.webView.delegate = self;
}

-(void)setupSearchTextField:(NSString *)string {
    [self.searchTextField setText:string];
}

- (IBAction)searchButtonTapped:(id)sender {
    NSString *searchTextString = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://wikipedia.org/search-redirect.php?family=wikipedia&search=%@&language=en", searchTextString];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadRequestFromString:urlString];
    });
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadRequest:urlRequest];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self extensionContext] completeRequestReturningItems:nil completionHandler:nil];
    });
}


@end
