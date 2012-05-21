//
//  NSString+TestAdditions.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TestAdditions)

+ (NSString*)stringWithContentsOfResource:(NSString *)resourceName bundledWithClass:(Class)aClass encoding:(NSStringEncoding)encoding error:(NSError **)error;

@end
