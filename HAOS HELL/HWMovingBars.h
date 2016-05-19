//
//  HWMovingBars.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/23/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HWMovingBars : SKSpriteNode
@property float startPosition;
@property float endPosition;



+(id)movingBars:(float)start;
-(float)getStartPosition;
-(void)mirror;
-(void)fadeIn:(SKSpriteNode *)node;
-(void)fadeOut:(SKSpriteNode *)node;

@end
