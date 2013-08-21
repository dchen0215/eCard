//
//  myParentViewController.m
//  eCard
//
//  Created by Daren Chen on 8/18/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "myParentViewController.h"

@interface myParentViewController ()

@end

@implementation myParentViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initialize our notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTargetCreated:) name:@"imageTargetCreated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTargetFailed:) name:@"imageTargetFailed" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification actions
- (void)imageTargetCreated:(NSNotification *)notification
{
    NSLog(@"Image target is successfully created.");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                    message:@"Your image target has been successfully uploaded to the Vuforia cloud database. Please allow 5-10 minutes for Vuforia to process that image to make it recognizable."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)imageTargetFailed:(NSNotification *)notification
{
    NSLog(@"Soemthing went wrong with the target creation.");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Something went wrong with the target creation. Please try again."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
