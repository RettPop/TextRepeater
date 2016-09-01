//
//  SpeechItem.h
//  TextRepeater
//
//  Created by Rett Pop on 2016-09-01.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechItem : NSObject<NSCoding>
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * language;
@property (nonatomic, assign) BOOL isSpokable;

+(instancetype)itemWithText:(NSString *)text language:(NSString *)language isSpokable:(BOOL)isSpokable;
-(instancetype)initWithText:(NSString *)text language:(NSString *)language isSpokable:(BOOL)isSpokable;

@end
