//
//  GameScene.h
//  HAOS HELL
//

//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/CAAnimation.h>
#import <CoreMotion/CoreMotion.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@end
