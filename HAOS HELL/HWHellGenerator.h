//
//  HWHellGenerator.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/21/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/CAAnimation.h>
#import "HWLevel6.h"
#import "HWFastEnemy.h"

@interface HWHellGenerator : SKSpriteNode

+(id)generatorWithWorld:(SKNode *)world;
-(void)initialize;
-(void)generateTop;
-(void)topAppear:(SKSpriteNode *)node;
-(void)generateBars;
-(void)generateNextLevel;
-(void)generateLevel1;
-(void)generateLevel2;
-(void)generateLevel3;
-(void)generateLevel4;
-(void)generateLevel5;
-(void)generateLevel6;
-(void)fillLevel1;
-(void)generateMovingBoxLeft:(CGPoint)boxXandStartX;
-(void)generateMovingBoxLeftSecondBar:(CGPoint)boxXandEndX;
-(void)generateMovingBoxRight:(CGPoint)boxXandEndX;
-(void)generateMovingBoxRightSecondBar:(CGPoint)boxXandStartX;
-(void)generateEnemy1;
-(void)generateEnemy2;
-(void)generateEnemy3;
-(void)boxMovingLeft:(SKSpriteNode *)node;
-(void)boxMOvingRight:(SKSpriteNode *)node;
-(void)Level6WithSpeedP:(HWLevel6 *)node;
-(void)Level6WithSpeedN:(HWLevel6 *)node;
-(void)enemy1MoveRight:(HWFastEnemy *)node;
-(void)enemy1MoveLeft:(HWFastEnemy *)node;
-(void)hellStartMoving;
-(void)hellSpeedUp;
-(void)hellSlowDown;
-(void)hellCrush;
-(void)hellStop;
-(int)getRandomLevelType;
-(int)getRandomBarSpeed;
-(int)getRandomItem;
-(int)getRandomEnemy;
-(float)getRandomEnemy1Speed;
-(void)blood:(CGPoint)bloodXY;
-(void)speedUpSign;
-(void)slowDownSign;
-(void)animateWithPulse:(SKNode *)node;
-(void)animateSlowDown:(SKNode *)node;


@end
