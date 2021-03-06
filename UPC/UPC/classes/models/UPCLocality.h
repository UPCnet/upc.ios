//
//  UPCLocality.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface UPCLocality : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (nonatomic)         double    latitude;
@property (nonatomic)         double    longitude;
@property (strong, nonatomic) NSArray *ownCenters;
@property (strong, nonatomic) NSArray *attachedCenters;

@end
