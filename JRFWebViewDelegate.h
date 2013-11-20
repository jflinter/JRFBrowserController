//
//  JRFWebViewDelegate.h
//  JFHN
//
//  Created by Jack Flintermann on 10/20/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRFWebViewController;

@protocol JRFWebViewDelegate<UIScrollViewDelegate>
- (void) webViewController:(JRFWebViewController *)controller
    didBlockLoadingRequest:(NSURLRequest *)request;
@end
