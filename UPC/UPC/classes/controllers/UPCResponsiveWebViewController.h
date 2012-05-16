//
//  UPCResponsiveWebViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UPCResponsiveWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end
