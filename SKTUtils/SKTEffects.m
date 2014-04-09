
#import "SKTEffects.h"
#import "SKTUtils.h"

@implementation SKTEffect

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration
{
	return [[[self class] alloc] initWithNode:node duration:duration];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration
{
	if ((self = [super init]))
	{
		self.node = node;
		self.duration = duration;
		self.timingFunction = SKTTimingFunctionLinear;
	}
	return self;
}

- (void)dealloc
{
	//NSLog(@"dealloc %@", self);
}

- (void)update:(float)t
{
	// subclass should implement this
}

@end

@implementation SKTMoveEffect
{
	CGPoint _startPosition;
	CGPoint _delta;
	CGPoint _previousPosition;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition {
    
	return [[[self class] alloc] initWithNode:node duration:duration startPosition:startPosition endPosition:endPosition];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition {
    
	if ((self = [self initWithNode:node duration:duration])) {
        
		_previousPosition = node.position;
		_startPosition = startPosition;
		_delta = CGPointSubtract(endPosition, _startPosition);
	}
	return self;
}

- (void)update:(float)t {
    
	// This allows multiple SKTMoveEffect objects to modify the same node
	// at the same time.

	CGPoint newPosition = CGPointAdd(_startPosition, CGPointMultiplyScalar(_delta, t));
	CGPoint diff = CGPointSubtract(newPosition, _previousPosition);
	_previousPosition = newPosition;

	self.node.position = CGPointAdd(self.node.position, diff);
}

@end

@implementation SKTScaleEffect {
    
	CGPoint _startScale;
	CGPoint _delta;
	CGPoint _previousScale;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale {
    
	return [[[self class] alloc] initWithNode:node duration:duration startScale:startScale endScale:endScale];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startScale:(CGPoint)startScale endScale:(CGPoint)endScale {
    
	if ((self = [self initWithNode:node duration:duration])) {
        
		_previousScale = CGPointMake(node.xScale, node.yScale);
		_startScale = startScale;
		_delta = CGPointSubtract(endScale, _startScale);
	}
	return self;
}

- (void)update:(float)t {
    
	CGPoint newScale = CGPointAdd(_startScale, CGPointMultiplyScalar(_delta, t));
	CGPoint diff = CGPointDivide(newScale, _previousScale);
	_previousScale = newScale;

	self.node.xScale *= diff.x;
	self.node.yScale *= diff.y;
}

@end

@implementation SKTFadeEffect {
    
	CGFloat _startFade;
	CGFloat _delta;
	CGFloat _previousFade;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startFade:(CGFloat)startFade endFade:(CGFloat)endFade {
    
	return [[[self class] alloc] initWithNode:node duration:duration startFade:startFade endFade:endFade];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startFade:(CGFloat)startFade endFade:(CGFloat)endFade {
    
	if ((self = [self initWithNode:node duration:duration])) {
        
		_previousFade = node.alpha;
		_startFade = startFade;
		_delta = endFade - _startFade;
	}
	return self;
}

- (void)update:(float)t {
    
	CGFloat newFade = _startFade + _delta * t;
	CGFloat diff = newFade - _previousFade;
	_previousFade = newFade;
    
	self.node.alpha += diff;
	//self.node.yScale *= diff.y;
}

@end


@implementation SKTRotateEffect {
    
	CGFloat _startAngle;
	CGFloat _delta;
	CGFloat _previousAngle;
}

+ (instancetype)effectWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    
	return [[[self class] alloc] initWithNode:node duration:duration startAngle:startAngle endAngle:endAngle];
}

- (instancetype)initWithNode:(SKNode *)node duration:(NSTimeInterval)duration startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    
	if ((self = [self initWithNode:node duration:duration])) {
        
		_previousAngle = node.zRotation;
		_startAngle = startAngle;
		_delta = endAngle - _startAngle;
	}
    
	return self;
}

- (void)update:(float)t {
    
	CGFloat newAngle = _startAngle + _delta * t;
	CGFloat diff = newAngle - _previousAngle;
	_previousAngle = newAngle;

	self.node.zRotation += diff;
}

@end

@implementation SKAction (SKTEffect)

+ (instancetype)actionWithEffect:(SKTEffect *)effect {
    
	return [[self class] customActionWithDuration:effect.duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
		CGFloat t = elapsedTime / effect.duration;

		if (effect.timingFunction != nil)
			t = effect.timingFunction(t);  // the magic happens here

		[effect update:t];
	}];
}

@end

@implementation SKAction (SKTEffects)

+ (instancetype)skt_screenShakeWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration {
    
	CGPoint oldPosition = node.position;
	CGPoint newPosition = CGPointAdd(oldPosition, amount);

	SKTMoveEffect *effect = [[SKTMoveEffect alloc] initWithNode:node duration:duration startPosition:newPosition endPosition:oldPosition];
	effect.timingFunction = SKTCreateShakeFunction(oscillations);

	return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_screenTumbleWithNode:(SKNode *)node angle:(CGFloat)angle oscillations:(int)oscillations duration:(NSTimeInterval)duration {
    
	CGFloat oldAngle = node.zRotation;
	CGFloat newAngle = oldAngle + angle;

	SKTRotateEffect *effect = [[SKTRotateEffect alloc] initWithNode:node duration:duration startAngle:newAngle endAngle:oldAngle];
	effect.timingFunction = SKTCreateShakeFunction(oscillations);

	return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_screenZoomWithNode:(SKNode *)node amount:(CGPoint)amount oscillations:(int)oscillations duration:(NSTimeInterval)duration {
    
	CGPoint oldScale = CGPointMake(node.xScale, node.yScale);
	CGPoint newScale = CGPointMultiply(oldScale, amount);

	SKTScaleEffect *effect = [[SKTScaleEffect alloc] initWithNode:node duration:duration startScale:newScale endScale:oldScale];
	effect.timingFunction = SKTCreateShakeFunction(oscillations);

	return [SKAction actionWithEffect:effect];
}

+ (instancetype)skt_colorGlitchWithScene:(SKScene *)scene originalColor:(SKColor *)originalColor duration:(NSTimeInterval)duration {
    
	return [[self class] customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
		if (elapsedTime < duration)
			scene.backgroundColor = SKColorWithRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
		else
			scene.backgroundColor = originalColor;
	}];
}

@end
