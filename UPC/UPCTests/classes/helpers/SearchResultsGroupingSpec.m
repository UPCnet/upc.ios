//
//  SearchResultsGroupingSpec.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "Kiwi.h"
#import "NSArray+SearchResultsGrouping.h"
#import "UPCSearchResult.h"
#import <MapKit/MapKit.h>


SPEC_BEGIN(SearchResultsGroupingSpec)

describe(@"SearchResultsGrouping", ^{
    __block NSDictionary *groupedSearchResults;
    
    context(@"when applied on an array of arbitrary objects", ^{
        beforeEach(^{
            NSArray *nonSearchResultsArray = [NSArray arrayWithObjects:@"not", @"a", @"search", @"result", nil];
            groupedSearchResults = [nonSearchResultsArray groupByLocation];
        });
        
        it(@"should return a dictionary", ^{
            [groupedSearchResults shouldNotBeNil];
        });
        
        it(@"should return an empty dictionary", ^{
            [[theValue([groupedSearchResults count]) should] equal:theValue(0)];
        });
    });
    
    context(@"when applied on an array of search results", ^{
        __block CLLocationCoordinate2D location1, location2;
        __block NSArray *searchResults;
        
        beforeAll(^{
            location1 = CLLocationCoordinate2DMake( 0.2894023,  0.9899812);
            location2 = CLLocationCoordinate2DMake(12.1578094, -5.0914832);
            
            UPCSearchResult *searchResult1 = [[UPCSearchResult alloc] init];
            searchResult1.identifier = @"1";
            searchResult1.latitude   = location1.latitude;
            searchResult1.longitude  = location1.longitude;
            
            UPCSearchResult *searchResult2 = [[UPCSearchResult alloc] init];
            searchResult2.identifier = @"2";
            searchResult2.latitude   = location2.latitude;
            searchResult2.longitude  = location2.longitude;
            
            UPCSearchResult *searchResult3 = [[UPCSearchResult alloc] init];
            searchResult3.identifier = @"3";
            searchResult3.latitude   = location1.latitude;
            searchResult3.longitude  = location1.longitude;
            
            searchResults = [NSArray arrayWithObjects:searchResult1, searchResult2, searchResult3, nil];
            groupedSearchResults = [searchResults groupByLocation];
        });
        
        it(@"should group the results with the same location", ^{
            [groupedSearchResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                UPCLocation *location = (UPCLocation *)key;
                NSArray *searchResultsInLocation = (NSArray *)obj;
                [searchResultsInLocation enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UPCSearchResult *searchResult = (UPCSearchResult *)obj;
                    [[theValue(location.coordinate.latitude)  should] equal:searchResult.latitude  withDelta:0];
                    [[theValue(location.coordinate.longitude) should] equal:searchResult.longitude withDelta:0];
                }];
            }];
        });
        
        it(@"should return the correct number of groups", ^{
            [[theValue([groupedSearchResults count]) should] equal:theValue(2)];
        });
        
        context(@"", ^{
            __block NSMutableArray *ungroupedSearchResults;
            
            beforeAll(^{
                ungroupedSearchResults = [[NSMutableArray alloc] init];
                [groupedSearchResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSArray *searchResultsInLocation = (NSArray *)obj;
                    [searchResultsInLocation enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [ungroupedSearchResults addObject:obj];
                    }];
                }];
            });
            
            it(@"should return the same number of results", ^{
                [[theValue([ungroupedSearchResults count]) should] equal:theValue([searchResults count])];
            });
            
            it(@"should return the same results from the original array", ^{
                [[[NSSet setWithArray:ungroupedSearchResults] should] equal:[NSSet setWithArray:searchResults]];
            });
        });
    });
});

SPEC_END


