//
//  UPCUnitViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCUnitViewController.h"


#pragma mark Class implementation

@implementation UPCUnitViewController

#pragma mark Synthesized properties

@synthesize unit = _unit;

#pragma mark Build unit data

- (void)setUnit:(UPCUnit *)unit
{
    self->_unit = unit;
    //TODO
}

@end
