//
//  UPCStructuredDataViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UITableViewCell* (^CellConfigurator)   (UITableView*, NSIndexPath*);
typedef CGFloat          (^CellHeightEstimator)(UITableView*, NSIndexPath*);
typedef void             (^CellAction)         (UITableView*, NSIndexPath*);


extern const CellHeightEstimator DEFAULT_HEIGHT_ESTIMATOR;


@interface UPCStructuredDataAction : NSObject

@property (strong, nonatomic) NSString   *label;
@property (strong, nonatomic) CellAction  action;

- (id)initWithLabel:(NSString *)label andAction:(CellAction)action;

@end


@interface UPCStructuredDataViewController : UITableViewController

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSArray *cellHeightEstimators;
@property (strong, nonatomic) NSArray *cellConfigurators;

@end
