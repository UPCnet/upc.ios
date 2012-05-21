//
//  UPCSearchResultGroup.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResultGroup.h"
#import "UPCSearchResult.h"


#pragma mark Class extension

@interface UPCSearchResultGroup ()
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end


#pragma mark Class implementation

@implementation UPCSearchResultGroup

#pragma mark Synthesized properties

@synthesize searchResults = _searchResults;
@synthesize coordinate    = _coordinate;

#pragma mark Init and dealloc

- (id)initWithSearchResults:(NSArray *)searchResults
{
    self = [super init];
    if (self) {
        self->_searchResults = searchResults;
    }
    return self;
}

#pragma mark Annotation methods

- (CLLocationCoordinate2D)coordinate
{
    UPCSearchResult *searchResult = (UPCSearchResult *)[self.searchResults objectAtIndex:0];
    return CLLocationCoordinate2DMake(searchResult.latitude, searchResult.longitude);
}

- (NSString *)title
{
    return ((UPCSearchResult *)[self.searchResults objectAtIndex:0]).name;
}

- (NSString *)subtitle
{
    if ([self.searchResults count] > 1) {
        return [NSString stringWithFormat:@"i %u resultat(s) més", [self.searchResults count] - 1];
    }
    else {
        return nil;
    }
}

@end
