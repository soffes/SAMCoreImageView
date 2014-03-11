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

@interface SAMCoreImageView : GLKView

@property (nonatomic) CIImage *image;

- (NSDictionary *)contextOptions;

@end
