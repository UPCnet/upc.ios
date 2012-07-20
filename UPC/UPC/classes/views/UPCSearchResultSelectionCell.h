//
//  UPCSearchResultSelectionCell.h
//  UPC
//
//  Created by Jose Gonzalez Gomez on 20/07/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UPCSearchResultSelectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel  *nameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *selectedSwitch;

@end
