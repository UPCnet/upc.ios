//
//  UPCQualificationsViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 04/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UPCQualificationsViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
