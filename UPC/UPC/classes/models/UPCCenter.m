//
//  UPCCenter.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCCenter.h"


@implementation UPCCenter

@synthesize identifier = _identifier;
@synthesize name       = _name;

- (NSString *)description
{
    return self.name;
}

@end
