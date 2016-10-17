//
//  JSQVisibleMediaItem.m
//  SocialChat
//
//  Created by ZhangJeff on 17/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQVisibleMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


@interface JSQVisibleMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;

@end


@implementation JSQVisibleMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image visibleTime:(NSString *)visibleTime replayedTime:(int)replayedTime messageKey:(NSString *)messageKey
{
    self = [super init];
    if (self) {
        _image = [image copy];
        self.visibleTime = visibleTime;
        self.replayedTime = replayedTime;
        self.messageKey = messageKey;
        _cachedImageView = nil;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}


- (void)addreplayedTime
{
    self.replayedTime += 1;
}


#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            imageView.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = imageView.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [imageView addSubview:blurEffectView];
            
            UILabel  *alertlabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 200, 20)];
            
            alertlabel.text = @"Tap to watch it!";
            alertlabel.font = [UIFont systemFontOfSize:20];
            alertlabel.textColor = [UIColor whiteColor];
            
            [imageView addSubview:alertlabel];
            
        } else {
            imageView.backgroundColor = [UIColor blackColor];
        }
        self.cachedImageView = imageView;
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVisibleMediaItem *copy = [[JSQVisibleMediaItem allocWithZone:zone] initWithImage:self.image visibleTime:self.visibleTime replayedTime:self.replayedTime messageKey:self.messageKey];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end

