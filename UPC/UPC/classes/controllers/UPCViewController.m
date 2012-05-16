//
//  UPCViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCViewController.h"


#pragma mark Class implementation

@implementation UPCViewController

#pragma Event management

- (IBAction)videosButtonTapped:(id)sender 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/es/institution/universitat-politecnica-catalunya./id465046416"]];
}

@end
