//
//  UPCAddressVideoCell.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 04/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCAddressVideoCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UPCAddressVideoCell

#pragma mark Synthesized properties

@synthesize addressLabel = _addressLabel;
@synthesize videoButton  = _videoButton;

#pragma mark Init and dealloc

- (void)dealloc
{
    self.addressLabel = nil;
    self.videoButton = nil;
}

@end
