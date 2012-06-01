//
//  UPCLocality.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCLocality.h"


@implementation UPCLocality

@synthesize name            = _name;
@synthesize latitude        = _latitude;
@synthesize longitude       = _longitude;
@synthesize ownCenters      = _ownCenters;
@synthesize attachedCenters = _attachedCenters;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (NSString *)title
{
    return self.name;
}

@end
