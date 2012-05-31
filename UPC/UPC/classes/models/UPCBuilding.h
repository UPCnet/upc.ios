//
//  UPCBuilding.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UPCBuilding : NSObject

@property (strong, nonatomic) NSString *campusName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSString *address;
@property (nonatomic)         double    latitude;
@property (nonatomic)         double    longitude;
@property (strong, nonatomic) NSArray  *units;

@end
