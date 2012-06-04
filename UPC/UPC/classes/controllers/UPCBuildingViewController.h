//
//  UPCBuildingViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"
#import "UPCStructuredDataViewController.h"
#import "UPCBuilding.h"


@interface UPCBuildingViewController : UPCStructuredDataViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) UPCBuilding *building;

@end
