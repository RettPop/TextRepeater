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

#define encObj(__name__)	{if(__name__) {[aCoder encodeObject:__name__ forKey:@#__name__];} }
#define encPoint(__name__)	[aCoder encodeCGPoint:__name__ forKey:@#__name__];
#define encSize(__name__)	[aCoder encodeCGSize:__name__ forKey:@#__name__];

#define encInt(__name__)	[aCoder encodeInt:__name__ forKey:@#__name__];
#define encFloat(__name__)	[aCoder encodeFloat:__name__ forKey:@#__name__];
#define encDouble(__name__)	[aCoder encodeDouble:__name__ forKey:@#__name__];
#define encBool(__name__)	[aCoder encodeBool:__name__ forKey:@#__name__];

////////////////////
////////////////////
#define decObj(__name__)	__name__ = [aDecoder decodeObjectForKey:@#__name__];
#define decInt(__name__)	__name__ = [aDecoder decodeIntForKey:@#__name__];
#define decFloat(__name__)	__name__ = [aDecoder decodeFloatForKey:@#__name__];
#define decDouble(__name__)	__name__ = [aDecoder decodeDoubleForKey:@#__name__];
#define decBool(__name__)	__name__ = [aDecoder decodeBoolForKey:@#__name__];
#define decPoint(__name__)	__name__ = [aDecoder decodeCGPointForKey:@#__name__];
#define decSize(__name__)	__name__ = [aDecoder decodeCGSizeForKey:@#__name__];


#endif /* TextRepeaterConstants_h */
