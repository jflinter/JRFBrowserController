//
//  JRFWebViewController.h
//  JFHN
//
//  Created by Jack Flintermann on 10/20/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRFWebViewDelegate.h"

@interface JRFWebViewController : UIViewController<UIWebViewDelegate>
@property(weak, nonatomic) id<JRFWebViewDelegate> delegate;
@property(nonatomic, readonly) UIWebView *webView;
- (id) initWithUrlRequest:(NSURLRequest *)request;
@property(nonatomic) NSURLRequest *request;
@end
