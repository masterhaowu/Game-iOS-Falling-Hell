//
//  HWDude.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/21/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWDude.h"

@interface HWDude ()

@property float currentDudeX;




@end

@implementation HWDude


static const uint32_t dudeCategory = 0x1 << 0;
static const uint32_t topCategory = 0x1 << 1;
static const uint32_t levelCategory = 0x1 << 2;
static const uint32_t barCategory = 0x1 << 3;
//static const uint32_t level6Category = 0x1 << 5;

+(id)dude
{
    //HWDude *dude = [HWDude spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(20, 20)];
    HWDude *dude = [HWDude spriteNodeWithImageNamed:@"guy"];

    
    
    
    
    dude.name = @"dude";
    //dude.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    //dude.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:13];
    dude.physicsBody = [SKPhysicsBody bodyWithTexture:dude.texture size:dude.size];
    dude.currentDudeX = 0;
    dude.physicsBody.categoryBitMask = dudeCategory;
    dude.physicsBody.allowsRotation = NO;
    dude.physicsBody.mass = 0.02;
    dude.physicsBody.contactTestBitMask = topCategory | ~levelCategory | ~barCategory;
    dude.pevDudeY = 0;
    dude.walkFrames = [NSMutableArray array];
    SKTexture *temp1 = [SKTexture textureWithImageNamed:@"guy"];
    SKTexture *temp2 = [SKTexture textureWithImageNamed:@"guymove"];
    SKTexture *temp3 = [SKTexture textureWithImageNamed:@"guymove1"];
    SKTexture *temp4 = [SKTexture textureWithImageNamed:@"guymove2"];

    [dude.walkFrames addObject:temp1];
    [dude.walkFrames addObject:temp2];
    [dude.walkFrames addObject:temp3];
    [dude.walkFrames addObject:temp4];
    return dude;
    
}

-(void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 10)];
}


-(void)moveLeft
{
    SKAction *incrementLeft = [SKAction moveByX:-1.0 y:0 duration:0.005];
    [self runAction:incrementLeft];
}



-(void)moveRight
{
    SKAction *incrementRight = [SKAction moveByX:1.0 y:0 duration:0.005];
    [self runAction:incrementRight];
}


-(void)moveDudeWithDelta:(float)delta
{
    //[self.physicsBody applyForce:CGVectorMake(30*delta, 0)];
    self.physicsBody.velocity = CGVectorMake(200*delta + self.physicsBody.velocity.dx/2, self.physicsBody.velocity.dy);

}



-(void)updateDude
{
    
}


-(void)moveOnLevel6WithSpeedP:(float)speed
{
    SKAction *moveRight = [SKAction moveByX:speed y:0 duration:0.005];
    [self runAction:moveRight];
    
}

-(void)moveOnLevel6WithSpeedN:(float)speed
{
    SKAction *moveLeft = [SKAction moveByX:-speed y:0 duration:0.005];
    [self runAction:moveLeft];
    
}

-(void)walking:(float)speed
{
    SKAction *walk = [SKAction animateWithTextures:self.walkFrames timePerFrame:speed resize:NO restore:YES];
    //[self runAction:walk];
    [self runAction:[SKAction repeatActionForever:walk] withKey:@"walkingInPlaceBear"];
    
    
}
                       


                


@end
