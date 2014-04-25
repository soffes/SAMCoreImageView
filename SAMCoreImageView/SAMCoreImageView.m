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
@property (nonatomic, readwrite) CIContext *ciContext;
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
	[self _display];
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
	CGRect bounds = CGRectMake(0.0f, 0.0f, size.width * scale, size.height * scale);
	CGRect imageRect = [self imageRectForBounds:self.bounds];
    [self.ciContext drawImage:self.image inRect:bounds fromRect:imageRect];
}


- (void)layoutSubviews {
	self.ciContext = nil;
	[self _display];
}


- (void)setContentMode:(UIViewContentMode)contentMode {
	[super setContentMode:contentMode];
	[self _display];
}


#pragma mark - Configuring

- (NSDictionary *)contextOptions {
	return @{
		kCIContextUseSoftwareRenderer: @NO,
		kCIContextWorkingColorSpace: [NSNull null]
	};
}


- (CGRect)imageRectForBounds:(CGRect)bounds {
	bounds.size.width *= self.contentScaleFactor;
	bounds.size.height *= self.contentScaleFactor;

	return SAMRectForContentMode(bounds, self.contentMode, self.image.extent);
}


#pragma mark - Private

- (void)_display {
	if (self.enableSetNeedsDisplay) {
		[self setNeedsDisplay];
	} else {
		[self display];
	}
}

@end
