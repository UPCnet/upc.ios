//
//  RKJSONParserJSONKit+TestAdditions.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "RKJSONParserJSONKit+TestAdditions.h"
#import "NSString+TestAdditions.h"


@implementation RKJSONParserJSONKit (TestAdditions)

- (NSDictionary *)objectFromResource:(NSString *)resourceName bundledWithClass:(Class)aClass error:(NSError **)error
{
    NSString *resource = [NSString stringWithContentsOfResource:resourceName bundledWithClass:aClass encoding:NSUTF8StringEncoding error:error];
    if (resource) {
        return [self objectFromString:resource error:error];
    }
    else {
        return nil;
    }
}

@end
