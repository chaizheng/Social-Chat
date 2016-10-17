

@import JSQMessagesViewController;


@interface JSQVisibleMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>


@property (copy, nonatomic) UIImage *image;


- (instancetype)initWithImage:(UIImage *)image;

@end
