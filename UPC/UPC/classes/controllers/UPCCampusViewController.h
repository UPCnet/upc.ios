//
//  UPCCampusViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPCStructuredDataViewController.h"
#import "UPCCampus.h"


@interface UPCCampusViewController : UPCStructuredDataViewController

@property (strong, nonatomic) UPCCampus *campus;

@end
