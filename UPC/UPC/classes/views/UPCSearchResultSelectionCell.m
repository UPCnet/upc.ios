//
//  UPCSearchResultSelectionCell.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 20/07/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResultSelectionCell.h"


@implementation UPCSearchResultSelectionCell

@synthesize nameLabel      = _nameLabel;
@synthesize selectedSwitch = _selectedSwitch;

- (void)sizeToFit
{
    self.nameLabel.frame = CGRectMake(20, 8, 193, 27);
    [self.nameLabel sizeToFit];
    [super sizeToFit];
}

#pragma mark Init and dealloc

- (void)dealloc
{
    self.nameLabel      = nil;
    self.selectedSwitch = nil;
}

@end
