

@import JSQMessagesViewController;


@interface JSQVisibleMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>


@property (copy, nonatomic) UIImage *image;
@property NSString* visibleTime;
@property int replayedTime;
@property NSString* messageKey;


- (instancetype)initWithImage:(UIImage *)image visibleTime:(NSString *)visibleTime replayedTime:(int)replayedTime messageKey:(NSString *)messageKey;

- (void)addreplayedTime;

@end
