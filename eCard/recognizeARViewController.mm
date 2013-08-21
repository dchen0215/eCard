//
//  recognizeARViewController.m
//  eCard
//
//  Created by Daren Chen on 8/18/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "recognizeARViewController.h"
#import "CRParentViewController.h"
#import "CRQCARutils.h"
#import "QCARHelper.h"

@interface recognizeARViewController ()

@end

@implementation recognizeARViewController

@synthesize arParentViewController;
static BOOL firstTime = YES;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize our notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissRecognizeAR:) name:@"dismissRecognizeAR" object:nil];
    
    // Create the CR-specific QCARutils object to replace the standard one and
    // set the device orientation lock to automatic mode
    CRQCARutils *qUtils = [CRQCARutils getInstance];
    qUtils.deviceOrientationLock = DeviceOrientationLockAuto;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: screenBounds];
    
    arParentViewController = [[CRParentViewController alloc] initWithWindow:window];
    
    [self presentViewController:arParentViewController animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // [self.navigationController setNavigationBarHidden:NO];
    
    //  Don't do this straight after startup - the view controller will do it
    if (firstTime == NO)
    {
        // do the same as when the view is shown
        [arParentViewController viewDidAppear:NO];
    }
    
    firstTime = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [arParentViewController viewDidDisappear:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [arParentViewController freeOpenGLESResources];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissRecognizeAR:(NSNotification *)notification
{
    NSLog(@"Recognize VC is being dismissed.");
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
