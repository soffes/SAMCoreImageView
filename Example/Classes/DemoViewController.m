//
//  DemoViewController.m
//  Example
//
//  Created by Sam Soffes on 2/6/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "DemoViewController.h"

#import <CoreImage/CoreImage.h>
#import <SAMCoreImageView/SAMCoreImageView.h>

@interface DemoViewController ()
@property (nonatomic) SAMCoreImageView *imageView;
@property (nonatomic) CIImage *inputImage;
@end

@implementation DemoViewController

#pragma mark - Accessors

@synthesize imageView = _imageView;

- (SAMCoreImageView *)imageView {
	if (!_imageView) {
		_imageView = [[SAMCoreImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 320.0f)];
	}
	return _imageView;
}


- (void)setInputImage:(CIImage *)inputImage {
	_inputImage = inputImage;
	self.imageView.image = _inputImage;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];

	self.inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"image"].CGImage];

	[self.view addSubview:self.imageView];

	UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10.0f, 350.0f, 300.0f, 32.0f)];
	[slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	slider.minimumValue = -1.0f;
	[self.view addSubview:slider];
}


#pragma mark - Actions

- (void)sliderChanged:(UISlider *)slider {
	CIFilter *vibrance = [CIFilter filterWithName:@"CIVibrance"];
	[vibrance setValue:self.inputImage forKey:@"inputImage"];
	[vibrance setValue:@(slider.value) forKey:@"inputAmount"];

	self.imageView.image = [vibrance outputImage];
}

@end
