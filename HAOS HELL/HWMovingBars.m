//
//  HWMovingBars.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/23/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWMovingBars.h"

@interface HWMovingBars ()


@end

@implementation HWMovingBars

+(id)movingBars:(float)start
{
    HWMovingBars *movingBars = [HWMovingBars spriteNodeWithImageNamed:@"arror_new20"];
    movingBars.name = @"movingBars";
    movingBars.startPosition = start; //this could also be the end position depends on the directons and the sides of the bars
    return movingBars;

}

-(float)getStartPosition
{
    return self.startPosition;
}


-(void)mirror
{
    [self setTexture:[SKTexture textureWithImageNamed:@"arror_new20_m"]];
}

-(void)fadeIn:(SKSpriteNode *)node
{
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.4];
    [node runAction:appear];
}

-(void)fadeOut:(SKSpriteNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.4];
    [node runAction:disappear];

}




@end
