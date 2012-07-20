//
//  UISwitch+SearchResultIndex.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 20/07/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UISwitch+SearchResultIndex.h"
#import <objc/runtime.h>


static char searchResultIndexKey;

@implementation UISwitch (SearchResultIndex)

- (void)setSearchResultIndex:(NSInteger)searchResultIndex
{
    objc_setAssociatedObject(self, &searchResultIndexKey, [NSNumber numberWithInteger:searchResultIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)searchResultIndex
{
    return [(NSNumber *)objc_getAssociatedObject(self, &searchResultIndexKey) integerValue];
}

@end
