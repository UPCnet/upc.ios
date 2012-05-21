//
//  UPCSearchResult.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>


extern NSString * const BUILDING_TYPE;
extern NSString * const UNIT_TYPE;


@interface UPCSearchResult : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (readonly, nonatomic) CLLocationCoordinate2D location;

@end
