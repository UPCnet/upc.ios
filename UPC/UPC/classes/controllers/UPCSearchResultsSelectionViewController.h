//
//  UPCSearchResultsSelectionViewController.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 20/07/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UPCSearchResultsSelectionViewController;


#pragma mark Delegate definition

@protocol UPCSearchResultsSelectionDelegate <NSObject>
- (void)selectionDone:(UPCSearchResultsSelectionViewController *)selectionViewController;
@end


#pragma mark Class definition

@interface UPCSearchResultsSelectionViewController : UITableViewController

@property (assign, nonatomic)   id<UPCSearchResultsSelectionDelegate> delegate;

@property (strong,   nonatomic) NSArray *searchResults;
@property (readonly, nonatomic) NSArray *selectedSearchResults;

- (IBAction)switchSearchResultSelection:(id)sender;
- (IBAction)selectionDone:(id)sender;

@end
