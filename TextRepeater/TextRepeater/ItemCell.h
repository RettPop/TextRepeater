//
//  ItemCell.h
//  TextRepeater
//
//  Created by Rett Pop on 2016-09-01.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemCell;

@protocol ItemCellDelegate <NSObject>
    @optional
    -(void)cell:(ItemCell*) cell activatityStateChangedTo:(BOOL)isActive;
@end


@interface ItemCell : UITableViewCell
    @property (strong, nonatomic) NSIndexPath *cellIndexPath;

    -(void)setDelegate:(id<ItemCellDelegate>)delegate;
    -(void)setCellText:(NSString *)text isActive:(BOOL) isActive isCurrent:(BOOL)isCurrent;
    -(void)setIsCurrent:(BOOL)isCurrent;
    -(BOOL)isActive;
@end
