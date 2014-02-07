//
//  SAMCoreImageView.m
//  SAMCoreImageView
//
//  Created by Sam Soffes on 2/6/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMCoreImageView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@interface SAMCoreImageView ()
@property (nonatomic, readonly) EAGLContext *eaglContext;
@property (nonatomic, readonly) CIContext *context;
@end

@implementation SAMCoreImageView {
	GLint _backingWidth;
	GLint _backingHeight;
	GLuint _frameBuffer;
	GLuint _renderBuffer;
	GLuint _depthBuffer;
}


#pragma mark - Accessors

@synthesize eaglContext = _eaglContext;
@synthesize context = _context;

- (EAGLContext *)eaglContext {
	if (!_eaglContext) {
		_eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

		if (!_eaglContext || ![EAGLContext setCurrentContext:_eaglContext]) {
			NSLog(@"ERROR: Couldn't create or set the EAGLContext during setup.");
			return nil;
		}
	}
	return _eaglContext;
}


- (CIContext *)context {
	if (!_context) {
		_context = [CIContext contextWithEAGLContext:self.eaglContext options:[self contextOptions]];
	}
	return _context;
}


- (void)setImage:(CIImage *)image {
	_image = image;
	[self drawView];
}


#pragma mark - NSObject

- (void)dealloc {
    [self tearDown];
}


#pragma mark - UIView

+ (Class)layerClass {
	return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;

		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		eaglLayer.opaque = YES;

		[self eaglContext];
		[self setup];
	}
	return self;
}


- (void)didMoveToWindow {
	[super didMoveToWindow];

	[self tearDown];
	[self setup];
}


- (void)layoutSubviews {
	if (_backingWidth != self.bounds.size.width || _backingHeight != self.bounds.size.height) {
		[self tearDown];
		[self setup];
	}
}


#pragma mark - Configuring

- (NSDictionary *)contextOptions {
	return @{
		kCIContextUseSoftwareRenderer: @NO
	};
}


#pragma mark - Private

- (void)drawView {
    if (!self.image) {
        return;
    }

    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

	CGSize size = self.bounds.size;
	CGFloat scale = self.window.screen.scale;
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width * scale, size.height * scale);

    [self.context drawImage:self.image inRect:rect fromRect:self.image.extent];

    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)setup {
	if (!self.window || CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
		return;
	}

	glGenFramebuffers(1, &_frameBuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

	glGenRenderbuffers(1, &_renderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
	[self.eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);

	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);

	glGenRenderbuffers(1, &_depthBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);

	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);

	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);

	glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);

	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
	if(status != GL_FRAMEBUFFER_COMPLETE) {
		NSLog(@"ERROR: Failed to make complete framebuffer object %x", status);
		return;
	}

	glViewport(0, 0, _backingWidth, _backingHeight);
	[self drawView];
}


- (void)tearDown {
	if (_frameBuffer) {
		glDeleteFramebuffers(1, &_frameBuffer);
		_frameBuffer = 0;
	}

	if (_renderBuffer) {
		glDeleteRenderbuffers(1, &_renderBuffer);
		_renderBuffer = 0;
	}

	if (_depthBuffer) {
		glDeleteRenderbuffers(1, &_depthBuffer);
		_depthBuffer = 0;
	}
}

@end
