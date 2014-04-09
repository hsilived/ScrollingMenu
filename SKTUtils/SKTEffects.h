
#import <SpriteKit/SpriteKit.h>
#import "SKTTimingFunctions.h"

/*!
 * Allows you to perform actions with custom timing functions.
 *
 * Unfortunately, SKAction does not have a concept of a timing function, so
 * we need to replicate the actions using SKTEffect subclasses.
 */
@interface SKTEffect : NSObject

@property (nonatomic, weak) SKNode *node;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) SKTTimingFunction timingFunction;

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration;

- (void)update:(float)t;

@end

/*!
 * Moves a node from its current position to a new position.
 */
@interface SKTMoveEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition;

@end

/*!
 * Scales a node to a certain scale factor.
 */
@interface SKTScaleEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale;

@end

/*!
 * fades a node to a certain fade factor.
 */
@interface SKTFadeEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startFade:(CGFloat)startFade endFade:(CGFloat)endFade;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startFade:(CGFloat)startFade endFade:(CGFloat)endFade;

@end

/*!
 * Rotates a node to a certain angle.
 */
@interface SKTRotateEffect : SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

@end

/*!
 * Wrapper that allows you to use SKTEffect objects as regular SKActions.
 */
@interface SKAction (SKTEffect)

+ (instancetype)actionWithEffect:(SKTEffect *)effect;

@end

@interface SKAction (SKTSpecialEffects)

/*!
 * Creates a screen shake animation.
 *
 * \param oscillations The number of oscillations. 10 is a good value.
 *
 * \note You cannot apply this to an SKScene.
 */
+ (instancetype)skt_screenShakeWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/*!
 * Creates a screen rotation animation.
 *
 * \param oscillations The number of oscillations. 10 is a good value.
 *
 * \note You can apply this to an SKScene. You probably want to set its 
 * anchorPoint to (0.5f, 0.5f).
 */
+ (instancetype)skt_screenTumbleWithNode:(SKNode *)node angle:(CGFloat)angle oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/*!
 * Creates a screen zoom animation.
 *
 * \param oscillations The number of oscillations. 10 is a good value.
 */
+ (instancetype)skt_screenZoomWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration;

/*!
 * Causes the scene background to flash for \a duration seconds.
 */
+ (instancetype)skt_colorGlitchWithScene:(SKScene *)scene originalColor:(SKColor *)color duration:(NSTimeInterval)duration;

@end
