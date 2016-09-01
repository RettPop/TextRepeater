//
//  ItemCell.m
//  TextRepeater
//
//  Created by Rett Pop on 2016-09-01.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "ItemCell.h"

#define kIconCurrentItem @"🔉"
#define kIconNotCurrentItem @"" //🔇
#define kIconActiveItem @"✅"
#define kIconInactiveItem @"❎"

@interface ItemCell()
{
    BOOL _isActive;
    BOOL _isCurrent;
}
    @property (weak, nonatomic) id<ItemCellDelegate> delegate;
    @property (strong, nonatomic) IBOutlet UIButton *btnActivateItem;
    @property (strong, nonatomic) IBOutlet UILabel *lblItemText;
    @property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@end

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnActivateTapped:(id)sender
{
    _isActive = !_isActive;
    [self setCellText:[_lblItemText text] isActive:_isActive isCurrent:_isCurrent];
    
    if( _delegate && [_delegate respondsToSelector:@selector(cell:activatityStateChangedTo:)] )
    {
        [_delegate cell:self activatityStateChangedTo:_isActive];
    }
}

-(void)setCellText:(NSString *)text isActive:(BOOL) isActive isCurrent:(BOOL)isCurrent
{
    _isActive = isActive;
    _isCurrent = isCurrent;
    [_lblItemText setText:text];
    [_lblStatus setText: _isCurrent ? kIconCurrentItem : kIconNotCurrentItem];
    [_btnActivateItem setTitle:(_isActive ? kIconActiveItem : kIconInactiveItem) forState:UIControlStateNormal];
}

-(void)setDelegate:(id<ItemCellDelegate>)delegate
{
    _delegate = delegate;
}

-(void)setIsCurrent:(BOOL)isCurrent
{
    _isCurrent = isCurrent;
    [self setCellText:[_lblItemText text] isActive:_isActive isCurrent:_isCurrent];
}

-(BOOL)isActive
{
    return _isActive;
}

@end
















