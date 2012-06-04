//
//  UPCSearchResultsViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"


@interface UPCSearchResultsViewController : UITableViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) NSArray *searchResults;

@end
