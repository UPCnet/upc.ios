//
//  UPCSearchResultGroup.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 21/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface UPCSearchResultGroup : NSObject <MKAnnotation>

@property (copy, nonatomic, readonly) NSArray *searchResults;

- (id) initWithSearchResults:(NSArray *)searchResults;

@end
