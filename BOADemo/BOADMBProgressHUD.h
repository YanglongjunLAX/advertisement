//
//  BOADMBProgressHUD.h
//  Version 0.8
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2013 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol BOADMBProgressHUDDelegate;

typedef enum {
	BOADMBProgressHUDModeIndeterminate,
	BOADMBProgressHUDModeDeterminate,
	BOADMBProgressHUDModeDeterminateHorizontalBar,
	BOADMBProgressHUDModeAnnularDeterminate,
	BOADMBProgressHUDModeCustomView,
	BOADMBProgressHUDModeText
} BOADMBProgressHUDMode;

typedef enum {
	BOADMBProgressHUDAnimationFade,
	BOADMBProgressHUDAnimationZoom,
	BOADMBProgressHUDAnimationZoomOut = BOADMBProgressHUDAnimationZoom,
	BOADMBProgressHUDAnimationZoomIn
} BOADMBProgressHUDAnimation;


#ifndef BOADMB_INSTANCETYPE
#if __has_feature(objc_instancetype)
	#define BOADMB_INSTANCETYPE instancetype
#else
	#define BOADMB_INSTANCETYPE id
#endif
#endif

#ifndef BOADMB_STRONG
#if __has_feature(objc_arc)
	#define BOADMB_STRONG strong
#else
	#define BOADMB_STRONG retain
#endif
#endif

#ifndef BOADMB_WEAK
#if __has_feature(objc_arc_weak)
	#define BOADMB_WEAK weak
#elif __has_feature(objc_arc)
	#define BOADMB_WEAK unsafe_unretained
#else
	#define BOADMB_WEAK assign
#endif
#endif

#if NS_BLOCKS_AVAILABLE
typedef void (^BOADMBProgressHUDCompletionBlock)();
#endif

@interface BOADMBProgressHUD : UIView

+ (BOADMB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

+ (BOADMB_INSTANCETYPE)HUDForView:(UIView *)view;

+ (NSArray *)allHUDsForView:(UIView *)view;

- (id)initWithWindow:(UIWindow *)window;

- (id)initWithView:(UIView *)view;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

#if NS_BLOCKS_AVAILABLE

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(BOADMBProgressHUDCompletionBlock)completion;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
		  completionBlock:(BOADMBProgressHUDCompletionBlock)completion;

@property (copy) BOADMBProgressHUDCompletionBlock completionBlock;

#endif

@property (assign) BOADMBProgressHUDMode mode;

@property (assign) BOADMBProgressHUDAnimation animationType;

@property (BOADMB_STRONG) UIView *customView;

@property (BOADMB_WEAK) id<BOADMBProgressHUDDelegate> delegate;

@property (copy) NSString *labelText;

@property (copy) NSString *detailsLabelText;

@property (assign) float opacity;

@property (BOADMB_STRONG) UIColor *color;

@property (assign) float xOffset;

@property (assign) float yOffset;

@property (assign) float margin;

@property (assign) float cornerRadius;

@property (assign) BOOL diBOADMBackground;

@property (assign) float graceTime;

@property (assign) float minShowTime;

@property (assign) BOOL taskInProgress;

@property (assign) BOOL removeFromSuperViewOnHide;

@property (BOADMB_STRONG) UIFont* labelFont;

@property (BOADMB_STRONG) UIColor* labelColor;

@property (BOADMB_STRONG) UIFont* detailsLabelFont;

@property (BOADMB_STRONG) UIColor* detailsLabelColor;

@property (assign) float progress;

@property (assign) CGSize minSize;

@property (assign, getter = isSquare) BOOL square;

@end


@protocol BOADMBProgressHUDDelegate <NSObject>

@optional

- (void)hudWasHidden:(BOADMBProgressHUD *)hud;

@end

@interface BOADMBRoundProgressView : UIView

@property (nonatomic, assign) float progress;

@property (nonatomic, BOADMB_STRONG) UIColor *progressTintColor;

@property (nonatomic, BOADMB_STRONG) UIColor *backgroundTintColor;

@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


@interface BOADMBBarProgressView : UIView

@property (nonatomic, assign) float progress;

@property (nonatomic, BOADMB_STRONG) UIColor *lineColor;

@property (nonatomic, BOADMB_STRONG) UIColor *progressRemainingColor;

@property (nonatomic, BOADMB_STRONG) UIColor *progressColor;

@end
