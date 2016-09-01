//
//  TextRepeaterConstants.h
//  TextRepeater
//
//  Created by Rett Pop on 2016-08-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#ifndef TextRepeaterConstants_h
#define TextRepeaterConstants_h

#define kDefsKeyTexts @"textsArray"

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"%@%s:(%d)> %@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DAssert(A, B, ...) NSAssert(A, B, ##__VA_ARGS__);
#define DLogv( var ) NSLog( @"%@%s:(%d)> "# var "=%@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, var ] )
#elif DEBUG_PROD
#define DLog( s, ... ) NSLog( @"%@%s:(%d)> %@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DLogv( var ) NSLog( @"%@%s:(%d)> "# var "=%@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, var ] )
#define DAssert(A, B, ...) NSAssert(A, B, ##__VA_ARGS__);
#else
#define DLog( s, ... )
#define DAssert(...)
#define DLogv(...)
#endif


#define LOC(key) NSLocalizedString((key), @"")
#define NSSTring NSString

#endif /* TextRepeaterConstants_h */
