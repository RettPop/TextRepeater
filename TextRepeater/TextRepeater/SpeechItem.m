//
//  SpeechItem.m
//  TextRepeater
//
//  Created by Rett Pop on 2016-09-01.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "SpeechItem.h"

@interface SpeechItem()
@end


@implementation SpeechItem

+(instancetype)itemWithText:(NSString *)text language:(NSString *)language isSpokable:(BOOL)isSpokable
{
    return [[SpeechItem alloc] initWithText:text language:language isSpokable:isSpokable];
}

-(instancetype)initWithText:(NSString *)text language:(NSString *)language isSpokable:(BOOL)isSpokable
{
    self = [super init];
    if( self )
    {
        _text = text;
        _language = language;
        _isSpokable = isSpokable;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    encObj(_text);
    encObj(_language);
    encBool(_isSpokable);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        decObj(_text);
        decObj(_language);
        decBool(_isSpokable);
    }
    
    return self;
}


@end
