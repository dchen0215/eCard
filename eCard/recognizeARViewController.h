//
//  recognizeARViewController.h
//  eCard
//
//  Created by Daren Chen on 8/18/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRParentViewController;

@interface recognizeARViewController : UIViewController
{
    UIWindow* window;
    CRParentViewController* arParentViewController;
    UIImageView *splashImageView;
}

@property (readonly, nonatomic) CRParentViewController* arParentViewController;

@end
