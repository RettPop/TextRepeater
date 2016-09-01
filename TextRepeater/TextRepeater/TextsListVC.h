//
//  ViewController.h
//  TextRepeater
//
//  Created by Rett Pop on 2016-08-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "ItemCell.h"

@interface TextsListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate, ItemCellDelegate>


@end

