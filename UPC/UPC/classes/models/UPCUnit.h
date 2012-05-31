//
//  UPCUnit.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UPCUnit : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *campusName;
@property (strong, nonatomic) NSString *acronym;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *directorName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *webAddress;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *youTubeVideoAddress;
@property (strong, nonatomic) NSString *photoAddress;
@property (strong, nonatomic) NSString *videoThumbnailAddress;
@property (strong, nonatomic) NSString *enrollmentWebAddress;
@property (nonatomic)         double    latitude;
@property (nonatomic)         double    longitude;
@property (strong, nonatomic) NSArray  *degrees;
@property (strong, nonatomic) NSArray  *jointDegrees;
@property (strong, nonatomic) NSArray  *masters;

@end
