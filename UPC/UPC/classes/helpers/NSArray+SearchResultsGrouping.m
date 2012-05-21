//
//  NSArray+SearchResultsGrouping.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "NSArray+SearchResultsGrouping.h"
#import "UPCSearchResult.h"


@implementation NSArray (SearchResultsGrouping)

- (NSDictionary *)groupByLocation
{
    NSMutableDictionary *groupedSearchResults = [[NSMutableDictionary alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UPCSearchResult class]]) {
            UPCSearchResult *searchResult = (UPCSearchResult *)obj;
            CLLocation *searchResultLocation = [[CLLocation alloc] initWithLatitude:searchResult.latitude longitude:searchResult.longitude];
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
