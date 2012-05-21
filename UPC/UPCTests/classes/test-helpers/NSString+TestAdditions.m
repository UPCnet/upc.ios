//
//  NSString+TestAdditions.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "NSString+TestAdditions.h"


@implementation NSString (TestAdditions)

+ (NSString*)stringWithContentsOfResource:(NSString *)resourceName bundledWithClass:(Class)aClass encoding:(NSStringEncoding)encoding error:(NSError **)error
{
    NSBundle *currentBundle = [NSBundle bundleForClass:aClass];
    NSURL *resourceURL = [currentBundle URLForResource:resourceName withExtension:nil];
    return [NSString stringWithContentsOfURL:resourceURL encoding:encoding error:error];
}

@end
