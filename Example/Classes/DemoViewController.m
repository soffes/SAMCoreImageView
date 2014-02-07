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
@property (nonatomic, readonly) SAMCoreImageView *imageView;
@property (nonatomic, readonly) UISlider *slider;
@property (nonatomic) CIImage *inputImage;
@end

@implementation DemoViewController

#pragma mark - Accessors

@synthesize imageView = _imageView;
@synthesize slider = _slider;

- (SAMCoreImageView *)imageView {
	if (!_imageView) {
		_imageView = [[SAMCoreImageView alloc] init];
	}
	return _imageView;
}


- (UISlider *)slider {
	if (!_slider) {
		_slider = [[UISlider alloc] init];
		[_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
		_slider.minimumValue = -1.0f;
	}
	return _slider;
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
	[self.view addSubview:self.slider];
}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	CGSize size = self.view.bounds.size;

	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
		self.imageView.frame = CGRectMake(0.0f, 20.0f, size.width, size.width);
	} else {
		self.imageView.frame = CGRectMake(roundf((size.width - 200.0f) / 2.0f), 20.0f, 200.0f, 200.0f);
	}
	self.slider.frame = CGRectMake(self.imageView.frame.origin.x + 10.0f, CGRectGetMaxY(self.imageView.frame) + 10.0f, self.imageView.frame.size.width - 20.0f, 32.0f);
}


#pragma mark - Actions

- (void)sliderChanged:(UISlider *)slider {
	CIFilter *vibrance = [CIFilter filterWithName:@"CIVibrance"];
	[vibrance setValue:self.inputImage forKey:@"inputImage"];
	[vibrance setValue:@(slider.value) forKey:@"inputAmount"];

	self.imageView.image = [vibrance outputImage];
}

@end
