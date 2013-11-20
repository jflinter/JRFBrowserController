//
//  JRFWebViewController.m
//  JFHN
//
//  Created by Jack Flintermann on 10/20/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "JRFWebViewController.h"
#import "JRFURLRouter.h"

@interface JRFWebViewController()
@property(nonatomic, weak) UIProgressView *progressView;
@property(nonatomic) BOOL finishedLoading;
@property(nonatomic, weak) UIRefreshControl *refreshControl;
@end

@implementation JRFWebViewController

- (id) initWithUrlRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        NSString *progressEstimateName = [@"WebProgressEstimateChanged" stringByAppendingString:@"Notification"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notified:) name:progressEstimateName object:nil];
        webView.delegate = self;
        webView.backgroundColor = [UIColor whiteColor];
        _webView = webView;
        _request = request;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = self.navigationController.view.tintColor;
    self.view.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    progressView.progressTintColor = self.view.tintColor;
    _progressView = progressView;
    _progressView.progress = 0.0f;
    self.webView.frame = self.view.bounds;
    self.webView.scrollView.delegate = self.delegate;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    self.finishedLoading = NO;
    _progressView.progress = 0.0f;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    self.refreshControl.tintColor = [UIColor appTintColor];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:refreshControl];
}

- (void) reload:(id)sender {
    self.progressView.progress = 0;
    [self.webView loadRequest:self.request];
    CGFloat progress = MAX(self.progressView.progress, 0.05);
    [self.progressView setProgress:progress animated:YES];
}

- (void) setDelegate:(id<JRFWebViewDelegate>)delegate {
    _delegate = delegate;
    self.webView.scrollView.delegate = delegate;
}

- (void) viewWillAppear:(BOOL)animated {
    if (!self.finishedLoading) {
        [self.webView loadRequest:self.request];
        CGFloat progress = MAX(self.progressView.progress, 0.05);
        [self.progressView setProgress:progress animated:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    self.finishedLoading = ![self.webView isLoading];
    [self.webView stopLoading];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect progressFrame = _progressView.frame;
    progressFrame.origin.y = [self.topLayoutGuide length];
    progressFrame.size.width = self.view.frame.size.width;
    _progressView.frame = progressFrame;
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        return YES;
    }
    
    if ([[JRFURLRouter sharedInstance] canRouteUrl:request.URL]) {
        [[JRFURLRouter sharedInstance] routeUrl:request.URL];
        return NO;
    }
    
    [self.delegate webViewController:self didBlockLoadingRequest:request];
    return NO;
}

- (void) notified:(NSNotification *)sender {
    NSString *key = @"WebProgressEstimatedProgressKey";
    CGFloat progress = [[sender.userInfo objectForKey:key] floatValue];
    if (self.isViewLoaded && self.view.window) {
        CGFloat adjustedProgress = MAX(self.progressView.progress, progress);
        if (adjustedProgress < 0.2f) {
            CGFloat test = 0.2f - powf((0.2f - adjustedProgress), 1.5);
            adjustedProgress = test;
        }
        if (self.progressView.progress < 0.05f) {
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.alpha = 1.0f;
            }];
        }
        self.progressView.progress = adjustedProgress;
        if (progress > 0.99f) {
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.alpha = 0.0f;
            }];
            [self.refreshControl endRefreshing];
            self.finishedLoading = YES;
        }
    }
}

@end
