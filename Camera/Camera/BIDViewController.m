//
//  BIDViewController.m
//  Camera
//
//  Created by Dexter Launchlabs on 8/1/14.
//  Copyright (c) 2014 Dexter Launchlabs. All rights reserved.
//

#import "BIDViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface BIDViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation BIDViewController
@synthesize imageView;
@synthesize takePictureButton; @synthesize moviePlayerController; @synthesize image;
@synthesize movieURL; @synthesize lastChosenMediaType; @synthesize imageFrame;- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        takePictureButton.hidden = YES; }
    imageFrame = imageView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateDisplay];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view. // e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.takePictureButton = nil; self.moviePlayerController = nil;
}
- (IBAction)shootPictureOrVideo:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
- (IBAction)selectExistingPictureOrVideo:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info { self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType]; if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage]; UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
    self.image = shrunkenImage;
} else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) { self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
}
    [picker dismissModalViewControllerAnimated:YES]; }
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale; CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, size.width * scale, size.height * scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context); UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context); CGImageRelease(shrunken);
    return final; }
- (void)updateDisplay {
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        imageView.image = image; imageView.hidden = NO; moviePlayerController.view.hidden = YES;
    } else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) { [self.moviePlayerController.view removeFromSuperview]; self.moviePlayerController = [[MPMoviePlayerController alloc]
                                                                                                                                                              initWithContentURL:movieURL]; moviePlayerController.view.frame = imageFrame; moviePlayerController.view.clipsToBounds = YES; [self.view addSubview:moviePlayerController.view]; imageView.hidden = YES;
    } }
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType { NSArray *mediaTypes = [UIImagePickerController
                                                                                                  availableMediaTypesForSourceType:sourceType]; if ([UIImagePickerController isSourceTypeAvailable:
                                                                                                                                                     sourceType] && [mediaTypes count] > 0) { NSArray *mediaTypes = [UIImagePickerController
                                                                                                                                                                                                                     availableMediaTypesForSourceType:sourceType]; UIImagePickerController *picker = [[UIImagePickerController alloc] init]; picker.mediaTypes = mediaTypes;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
} else {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error accessing media" message:@"Device doesn’t support that media source." delegate:nil
                          cancelButtonTitle:@"Drat!"
                          otherButtonTitles:nil];
    [alert show]; }
}
    
@end
