//
//  RKJSONParserJSONKit+TestAdditions.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "RestKit/RKJSONParserJSONKit.h"


@interface RKJSONParserJSONKit (TestAdditions)

- (NSDictionary *)objectFromResource:(NSString *)resourceName bundledWithClass:(Class)aClass error:(NSError **)error;

@end
