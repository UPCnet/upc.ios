//
//  UPCRestKitConfigurator.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"


@interface UPCRestKitConfigurator : NSObject

+ (RKObjectManager *)sharedManager;

@end
