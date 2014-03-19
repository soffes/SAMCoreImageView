# SAMCoreImageView

Render a CIImage in an OpenGL thingy so it's real fast and junk. You won't see any speed up on the simulator, but on the device it's nuts fast.

This is was inspired by [TLDFastCoreImageView](https://github.com/patr1ck/TLDCoreImageDemo/blob/master/TLDCoreImageDemo/TLDFastCoreImageView.h) by [Patrick Gibson](https://github.com/patr1ck). Thanks Patrick!

## Usage

``` objc
SAMCoreImageView *imageView = [[SAMCoreImageView alloc] init];
imageView.image = [someFilter outputImage];
```

SAMCoreImageView's `contentMode` behaves just like UIImageView's so go nuts. Internally, it uses [SAMContentMode](https://github.com/soffes/SAMContentMode) to do its magic.
