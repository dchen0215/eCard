//
//  createARViewController.m
//  eCard
//
//  Created by Daren Chen on 8/18/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "createARViewController.h"

@interface createARViewController ()

@end

@implementation createARViewController

@synthesize imagePicker;
@synthesize imagetTarget;
@synthesize enterTargetName;
@synthesize targetID;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self checkInternet])
    {
        NSLog(@"Camera is launched");
        self.imagePicker = [[UIImagePickerController alloc] init];
        
        // If our device has a camera, we want to take a picture, otherwise, we
        // just pick from photo library
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        self.imagePicker.delegate = self;
        [self.view addSubview:imagePicker.view];
        // [self presentViewController:self.imagePicker animated:YES completion:nil];
        
        // Gesture recognizer for dismissing the VC
        UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognized:)];
        [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.imagePicker.view addGestureRecognizer:gesture];
    }
    else
    {
        NSLog(@"No internet conenction.");
        // Show an alert view if no network
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Check Your Network Connection."
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize our notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTargetSubmitted:) name:@"imageTargetSubmitted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissCreateAR:) name:@"dismissCreateAR" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Cancel button pressed
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCreateAR" object:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imagetTarget = tempImage;
    NSLog(@"A photo has been taken.");
    
    // Now we need to send the image to Vuforia cloud database
    // to be set as a new image target
    
    // Shrink the photo
    CGSize shrinkSize = CGSizeMake(self.imagetTarget.size.width / 2.5, self.imagetTarget.size.height / 2.5);
    self.imagetTarget = [self resizeImage:self.imagetTarget toSize:shrinkSize];
    
    // Prompt the user for the target name - doesn't really matter though
    UIAlertView *askForTargetName = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please Name Your Photo", @"new_list_dialog")
                                                    message:@"Your friend will be prompted for entering that name before he or she can view the content out of the photo. So choose wisely!\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Submit", nil];
    self.enterTargetName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 130.0, 260.0, 25.0)];
    [self.enterTargetName becomeFirstResponder];
    [self.enterTargetName setBackgroundColor:[UIColor whiteColor]];
    [askForTargetName addSubview:self.enterTargetName];
    [askForTargetName show];
    
    // Continue in the alert view delegate method
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"OK!"])
    {
        // Go back to the front page
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCreateAR" object:nil];
    }
    else if ([title isEqualToString:@"Cancel"])
    {
        // Dismiss the keyboard before dismiss the VC
        [self.enterTargetName resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCreateAR" object:nil];
    }
    else if ([title isEqualToString:@"OK"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCreateAR" object:nil];
    }
    else if ([title isEqualToString:@"Submit"])
    {
        NSLog(@"%@ is entered.", self.enterTargetName.text);
        self.targetName = self.enterTargetName.text;
    
        // Prompt the user to enter a personal message
        
        // Post the image target
        // Use notification center so that we can easily run the posting in a background thread
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageTargetSubmitted" object:nil];
    }
}


#pragma mark - Helper functions
// Check if we have internet connection
- (BOOL)checkInternet
{
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.apple.com"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	if ([NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil])
		return TRUE;
	return FALSE;
}

// Shrink the image as Vuforia only allows image smaller than 2.25MB
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    
    [image drawInRect: rect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (void)postImageTarget
{
    NSString *result = @"";
    if (![self checkInternet])
    {
        NSLog(@"No internet conenction.");
        // Show an alert view if no network
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Operation Aborted"
                                                        message:@"Network connection is required to perfrom the following action. Please make sure you are connected to the internet and retake the photo."
                                                       delegate:self
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        PostNewTarget *postNewTarget = [[PostNewTarget alloc] init];
        postNewTarget.targetName = self.targetName;
        postNewTarget.imageTarget = self.imagetTarget;
        postNewTarget.metaData = @"samplebook1.json";
        
        self.targetID = [postNewTarget postTarget];
        result = postNewTarget.resultCode;
    }
    
    // First check the state of the VC
    // If it has been dismissed, do not pop the alert view, otherwise the app may crash
    if (self.parentViewController != nil)
    {
        if (self.targetID != nil)
        {
            NSLog(@"%@ is successfully created.", self.targetID);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                            message:@"Your image target has been successfully uploaded to the Vuforia cloud database. Please allow 5-10 minutes for Vuforia to process that image to make it recognizable."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSLog(@"Soemthing went wrong with the target creation.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Something went wrong with the target creation. Please try again.\n\nError Code: %@.", result]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    // If the VC has been dismissed, generate a notification instead of an alert view
    // and let the parent VC handle it
    else
    {
        if (self.targetID != nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageTargetCreated" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageTargetFailed" object:nil];
        }
    }
}


#pragma mark - Notification actions
- (void)imageTargetSubmitted:(NSNotification *)notification
{
    // Call the method to upload the image target
    // which potentially could be a lengthy operation, so perform it on a
    // background thread
    [self performSelectorInBackground:@selector(postImageTarget) withObject:nil];
    
    // Add a UIActivityIndicatorView to show that we are doing something
    UIActivityIndicatorView *anActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [anActivityIndicator startAnimating];
    anActivityIndicator.center = self.imagePicker.view.center;
    [self.imagePicker.view addSubview:anActivityIndicator];
}

- (void)dismissCreateAR:(NSNotification *)notification
{
    NSLog(@"CreateAR VC is being dismissed.");
    // [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Gesture recognizer action
- (void)gestureRecognized:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"Gesture is recognized.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCreateAR" object:nil];
}

@end
