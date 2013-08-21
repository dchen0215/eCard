//
//  createARViewController.h
//  eCard
//
//  Created by Daren Chen on 8/18/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostNewTarget.h"

@interface createARViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, readwrite) UIImagePickerController *imagePicker;
@property (nonatomic, readwrite) UIImage *imagetTarget;
@property (nonatomic, readwrite) UITextField *enterTargetName;
@property (nonatomic, readwrite) NSString *targetName;
@property (nonatomic, readwrite) NSString *targetID;

- (BOOL) checkInternet;
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
- (void)postImageTarget;

@end
