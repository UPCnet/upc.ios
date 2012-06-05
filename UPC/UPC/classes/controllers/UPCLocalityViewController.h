//
//  UPCLocalityViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"
#import "UPCStructuredDataViewController.h"
#import "UPCLocality.h"


@interface UPCLocalityViewController : UPCStructuredDataViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) UPCLocality *locality;

@end
