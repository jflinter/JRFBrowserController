//
//  JRFURLRouter.h
//  JFHN
//
//  Created by Jack Flintermann on 10/18/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRFUrlHandler <NSObject>

- (BOOL) canHandleUrl:(NSURL *)url;
- (void) handleUrl:(NSURL *)url;

@end

@interface JRFTwitterUrlHandler : NSObject <JRFUrlHandler>
@end

@interface JRFURLRouter : NSObject

+ (instancetype) sharedInstance;
- (BOOL) canRouteUrl:(NSURL *)url;
- (void) routeUrl:(NSURL *)url;
- (void) addHandler:(id<JRFUrlHandler>)handler;
- (void) removeHandler:(id<JRFUrlHandler>)handler;

@end
