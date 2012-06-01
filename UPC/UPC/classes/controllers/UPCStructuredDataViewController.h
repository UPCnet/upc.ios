//
//  UPCStructuredDataViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UITableViewCell* (^CellConfigurator)(UITableView*, NSIndexPath*);


@interface UPCStructuredDataViewController : UITableViewController

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSArray *cellConfigurators;

@end
