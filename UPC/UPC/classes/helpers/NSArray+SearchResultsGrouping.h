//
//  NSArray+SearchResultsGrouping.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


#pragma mark UPCLocation interface

@interface UPCLocation : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSNumber *latitude;
@property (strong, nonatomic, readonly) NSNumber *longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end


#pragma mark NSArray category

@interface NSArray (SearchResultsGrouping)

- (NSDictionary *)groupByLocation;

@end
