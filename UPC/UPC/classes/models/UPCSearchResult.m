//
//  UPCSearchResult.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResult.h"


NSString * const BUILDING_TYPE = @"edifici";
NSString * const UNIT_TYPE     = @"unitat";


#pragma mark Class implementation

@implementation UPCSearchResult

#pragma mark Synthesized properties

@synthesize type;
@synthesize identifier;
@synthesize name;
@synthesize latitude;
@synthesize longitude;

@end
