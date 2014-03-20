//
//  SAMCoreImageView.h
//  SAMCoreImageView
//
//  Created by Sam Soffes on 2/6/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

@import Foundation;
@import GLKit;
@class CIImage;

/**
 Fast image view for Core Image.
 */
@interface SAMCoreImageView : GLKView

/**
 The image to draw into the receiver.
 */
@property (nonatomic) CIImage *image;

/**
 The Core Image context (read-only).
 
 This is configured to draw into the view's EAGLContext with `contextOptions`.
 */
@property (nonatomic, readonly) CIContext *ciContext;

/**
 Options used to initalize the CIContext.
 
 @return CIContext options.
 */
- (NSDictionary *)contextOptions;

/**
 Get a rect in the CIImage's coordinate space in pixels for drawing.
 
 @param bounds The receiver's bounds (in points).
 @return The rect to draw.
 */
- (CGRect)imageRectForBounds:(CGRect)bounds;

@end
