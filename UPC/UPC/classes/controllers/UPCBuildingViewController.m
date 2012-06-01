//
//  UPCBuildingViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCBuildingViewController.h"


#pragma mark Class implementation

@implementation UPCBuildingViewController

# pragma mark Synthesized properties

@synthesize building = _building;

#pragma mark Build building data

- (void)setBuilding:(UPCBuilding *)building
{
    self->_building = building;
    //TODO
}

@end
