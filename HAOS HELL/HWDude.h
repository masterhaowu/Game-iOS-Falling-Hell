//
//  HWDude.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/21/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HWDude : SKSpriteNode
@property float pevDudeY;
@property NSMutableArray *walkFrames;

+(id)dude;
-(void)moveDudeWithDelta:(float)delta;
-(void)jump;
-(void)moveLeft;
-(void)moveRight;
-(void)updateDude;
-(void)moveOnLevel6WithSpeedP:(float)speed;
-(void)moveOnLevel6WithSpeedN:(float)speed;
-(void)walking:(float)speed;


@end
