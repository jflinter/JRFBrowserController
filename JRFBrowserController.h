//
//  JRFBrowserController.h
//  JFHN
//
//  Created by Jack Flintermann on 10/13/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRFWebViewDelegate.h"

typedef NS_OPTIONS(NSInteger, JRFToolbarMode) {
    JRFToolbarModeHidden = 0,
    JRFToolbarModeInteractive = 1,
    JRFToolbarModeVisible = 3
};

@interface JRFBrowserController : UIViewController<UINavigationControllerDelegate, JRFWebViewDelegate>
- (id) initWithUrl:(NSURL *)url;
@property(nonatomic, readwrite, weak) UIToolbar *toolbar;
@property(nonatomic, weak) UINavigationController *navController;
- (JRFWebViewController *)visibleWebViewController;
@property(nonatomic) JRFToolbarMode toolbarMode;
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
