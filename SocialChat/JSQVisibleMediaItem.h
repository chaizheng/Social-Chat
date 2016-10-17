

@import JSQMessagesViewController;


@interface JSQVisibleMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>


@property (copy, nonatomic) UIImage *image;
@property(nonatomic) NSString* visibleTime;

- (instancetype)initWithImage:(UIImage *)image;


@end
