//
//  SAMCoreImageView.h
//  SAMCoreImageView
//
//  Created by Sam Soffes on 2/6/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

@interface SAMCoreImageView : UIView

@property (nonatomic, strong) CIImage *image;

- (NSDictionary *)contextOptions;

@end
