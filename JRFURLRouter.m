//
//  JRFURLHandler.m
//  JFHN
//
//  Created by Jack Flintermann on 10/18/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "JRFURLRouter.h"

@interface JRFURLRouter()
@property(nonatomic) NSMutableArray *urlHandlers;
@end

@implementation JRFURLRouter

static JRFURLRouter *sharedInstance;
+ (instancetype) sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        _urlHandlers = [NSMutableArray array];
        [_urlHandlers addObject:[JRFTwitterUrlHandler new]];
    }
    return self;
}

- (id<JRFUrlHandler>)handlerForUrl:(NSURL *)url {
    for (id<JRFUrlHandler> handler in self.urlHandlers) {
        if ([handler canHandleUrl:url]) {
            return handler;
        }
    }
    return nil;
}

- (BOOL) canRouteUrl:(NSURL *)url {
    return [self handlerForUrl:url] != nil;
}

- (void) routeUrl:(NSURL *)url {
    [[self handlerForUrl:url] handleUrl:url];
}

- (void) addHandler:(id<JRFUrlHandler>)handler {
    [self.urlHandlers addObject:handler];
}

- (void) removeHandler:(id<JRFUrlHandler>)handler {
    [self.urlHandlers removeObject:handler];
}

@end


#pragma mark - URL handler classes

@implementation JRFTwitterUrlHandler

- (BOOL) canHandleUrl:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    return [components.host rangeOfString:@"twitter.com"].location != NSNotFound;
}

- (void) handleUrl:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

@end
