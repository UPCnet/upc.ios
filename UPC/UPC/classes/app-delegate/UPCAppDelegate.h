//
//  UPCAppDelegate.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GAI.h>

@interface UPCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
