//
//  SAMCoreImageView.m
//  SAMCoreImageView
//
//  Created by Sam Soffes on 2/6/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMCoreImageView.h"
#import <SAMContentMode/SAMContentMode.h>

@import OpenGLES;
@import CoreImage;

@interface SAMCoreImageView ()
@property (nonatomic, readonly) CIContext *ciContext;
@end

@implementation SAMCoreImageView


#pragma mark - Accessors

@synthesize ciContext = _ciContext;

- (CIContext *)ciContext {
	if (!_ciContext) {
		_ciContext = [CIContext contextWithEAGLContext:self.context options:[self contextOptions]];
	}
	return _ciContext;
}


- (void)setImage:(CIImage *)image {
	_image = image;
	[self display];
}


#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
	EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if ((self = [super initWithFrame:frame context:context])) {
		self.userInteractionEnabled = NO;
		self.enableSetNeedsDisplay = NO;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	if (!self.image) {
        return;
    }

	CGSize size = self.bounds.size;
	CGFloat scale = self.contentScaleFactor;
	CGRect frame = CGRectMake(0.0f, 0.0f, size.width * scale, size.height * scale);
	rect = SAMRectForContentMode(frame, self.contentMode, self.image.extent);
    [self.ciContext drawImage:self.image inRect:frame fromRect:rect];
}


- (void)layoutSubviews {
	[self display];
}


- (void)setContentMode:(UIViewContentMode)contentMode {
	[super setContentMode:contentMode];
	[self display];
}


#pragma mark - Configuring

- (NSDictionary *)contextOptions {
	return @{
		kCIContextUseSoftwareRenderer: @NO,
		kCIContextWorkingColorSpace: [NSNull null]
	};
}

@end
