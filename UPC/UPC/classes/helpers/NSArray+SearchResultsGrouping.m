//
//  NSArray+SearchResultsGrouping.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "NSArray+SearchResultsGrouping.h"
#import "UPCSearchResult.h"


#pragma mark UPCLocation class implementation

@implementation UPCLocation

#pragma mark Synthesized properties

@synthesize latitude  = _latitude;
@synthesize longitude = _longitude;

#pragma mark Init and dealloc

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    self = [super init];
    if (self) {
        self->_latitude  = [NSNumber numberWithDouble:latitude];
        self->_longitude = [NSNumber numberWithDouble:longitude];
    }
    return self;
}

#pragma mark Coordinate

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

#pragma mark Methods to behave as dictionary key

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    else if ([object isMemberOfClass:[self class]]) {
        UPCLocation *location = (UPCLocation *)object;
        return [self.latitude isEqualToNumber:location.latitude] && [self.longitude isEqualToNumber:location.longitude];
    }
    else {
        return NO;
    }
}

- (NSUInteger)hash
{
    return [self.latitude unsignedIntegerValue] ^ [self.longitude unsignedIntegerValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    UPCLocation *copiedLocation = [[UPCLocation allocWithZone:zone] init];
    copiedLocation->_latitude   = self.latitude;
    copiedLocation->_longitude  = self.longitude;
    return copiedLocation;
}

@end


# pragma mark - Category implementation

@implementation NSArray (SearchResultsGrouping)

- (NSDictionary *)groupByLocation
{
    NSMutableDictionary *groupedSearchResults = [[NSMutableDictionary alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UPCSearchResult class]]) {
            UPCSearchResult *searchResult = (UPCSearchResult *)obj;
            UPCLocation *searchResultLocation = [[UPCLocation alloc] initWithLatitude:searchResult.latitude longitude:searchResult.longitude];
            NSMutableArray *searchResultsInSameLocation = [groupedSearchResults objectForKey:searchResultLocation];
            if (!searchResultsInSameLocation) {
                searchResultsInSameLocation = [[NSMutableArray alloc] init];
                [groupedSearchResults setObject:searchResultsInSameLocation forKey:searchResultLocation];
            }
            [searchResultsInSameLocation addObject:searchResult];
        }
    }];
    return groupedSearchResults;
}

@end
