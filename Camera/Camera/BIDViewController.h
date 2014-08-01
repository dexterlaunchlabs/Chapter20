//
//  BIDViewController.h
//  Camera
//
//  Created by Dexter Launchlabs on 8/1/14.
//  Copyright (c) 2014 Dexter Launchlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface BIDViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController; @property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@property (assign, nonatomic) CGRect imageFrame;
- (IBAction)shootPictureOrVideo:(id)sender;
- (IBAction)selectExistingPictureOrVideo:(id)sender;

@end
