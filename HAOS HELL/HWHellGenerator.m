//
//  HWHellGenerator.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/21/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWHellGenerator.h"
#import "HWMovingBars.h"
#import "HWLevel6.h"
#import "HWFastEnemy.h"

@interface HWHellGenerator ()

@property SKNode *world;
@property float worldSpeed;
@property float currentSpeed;
@property float levelInterval;
@property float openingSize;
@property float openingRange;
@property float currentBarY;
@property float currentLevelY;
@property int levelType;
//type 1 level is the regular level. Two bars with opening in between.
@property float level1open;
//type 2 level is a regular level, with 1 obstacle on one of the bars
@property float level2open;
@property float level2ObsX;
@property float obsSizeX;
@property float obsSizeY;
//type 3 level is a regular level, with 2 obstacles
@property float level3open;
@property float level3Obs1X;
@property float level3Obs2X;
//type 4 level is a regular level, with 3 obstacles
@property float level4open;
@property float level4Obs1X;
@property float level4Obs2X;
@property float level4Obs3X;
//type 5 level is a floating short bar
@property float level5startX;
@property float level5sizeX;
@property int level5item; //item on level 5 bar. 0 means nothing, 1 means slow motion
//type 6 level is a floating short bar that moves
@property float level6speedX;
@property float level6sizeX;
//peedbar 0 means regular level, 1 is level moves left, 2 is level moves right.
@property int speedbarX;
//@property float startPositionMovingLeft;
//startPositionMovingLeft is where we generate the box when the bar is moving left.
@property int enemyType; //0 means no enemy, 1 means fastEnemy

@end



@implementation HWHellGenerator

static const uint32_t topCategory = 0x1 << 1;
static const uint32_t levelCategory = 0x1 << 2;
static const uint32_t barCategory = 0x1 << 3;
static const uint32_t obsCategory = 0x1 << 4;
static const uint32_t level6Category = 0x1 << 5;
//static const uint32_t enemy1Category = 0x1 << 6;

+(id)generatorWithWorld:(SKNode *)world
{
    HWHellGenerator *generator = [HWHellGenerator node];
    
    generator.worldSpeed = 2.5;
    generator.currentSpeed = generator.worldSpeed;
    
    generator.world = world;
    generator.levelInterval = 130;
    generator.openingSize = 60;
    generator.currentBarY = 0;
    generator.obsSizeX = 20;
    generator.obsSizeY = 50;

    
    
    return generator;
}



-(void)initialize
{
    self.openingRange = (self.scene.frame.size.width - 20 - self.openingSize);
    
    SKSpriteNode *barInit = [SKSpriteNode spriteNodeWithImageNamed:@"initbar"];
    barInit.name = @"barInit";
    barInit.position = CGPointMake(0, -100);
    barInit.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:barInit.size];
    //barInit.physicsBody = [SKPhysicsBody bodyWithTexture:barInit.texture size:barInit.size];
    barInit.physicsBody.dynamic = NO;
    barInit.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:barInit];
    
    int opening = self.scene.frame.size.width/2 - 30;
    SKSpriteNode *obstacleInitLeft = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    obstacleInitLeft.name = @"level";
    obstacleInitLeft.position = CGPointMake(0 - obstacleInitLeft.size.width/2 - self.scene.frame.size.width/2 + 10 + opening, self.levelInterval/2 - self.scene.frame.size.height/2);
    obstacleInitLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacleInitLeft.size];
    //obstacleInitLeft.physicsBody = [SKPhysicsBody bodyWithTexture:obstacleInitLeft.texture size:obstacleInitLeft.size];
    obstacleInitLeft.physicsBody.dynamic = NO;
    obstacleInitLeft.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:obstacleInitLeft];
    
    SKSpriteNode *obstacleInitRight = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    obstacleInitRight.name = @"levelo";
    obstacleInitRight.position = CGPointMake(10 + opening + self.openingSize - self.scene.frame.size.width/2 + obstacleInitRight.size.width/2, self.levelInterval/2 - self.scene.frame.size.height/2);
    obstacleInitRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacleInitRight.size];
    //obstacleInitRight.physicsBody = [SKPhysicsBody bodyWithTexture:obstacleInitRight.texture size:obstacleInitRight.size];
    obstacleInitRight.physicsBody.dynamic = NO;
    obstacleInitRight.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:obstacleInitRight];
    
 
    self.currentLevelY =  - self.scene.frame.size.height/2 - self.levelInterval/2;
    //[self generateLevel5];
    //[self generateLevel5];
    [self fillLevel1];
    
}



-(void)generateTop
{
    SKSpriteNode *Top = [SKSpriteNode spriteNodeWithImageNamed:@"nail"];
    Top.name = @"top";
    Top.position = CGPointMake(0, self.scene.frame.size.height/2 + 10);
    Top.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:Top.size];
    Top.physicsBody.dynamic = NO;
    Top.physicsBody.categoryBitMask = topCategory;
    [self addChild:Top];
    [self topAppear:Top];
    
    
}

-(void)topAppear:(SKSpriteNode *)node
{
    SKAction *incrementDown = [SKAction moveByX:0 y:-0.5 duration:0.03];
    SKAction *moveDown = [SKAction repeatAction:incrementDown count:40];
    [node runAction:moveDown];
}



-(void)generateBars
{
    SKSpriteNode *barLeft = [SKSpriteNode spriteNodeWithImageNamed:@"bar"];
    barLeft.name = @"bar";
    barLeft.position = CGPointMake(-self.scene.frame.size.width/2 - barLeft.size.width/2 + 10, self.currentBarY);
    barLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:barLeft.size];
    barLeft.physicsBody.dynamic = NO;
    barLeft.physicsBody.categoryBitMask = barCategory;
    barLeft.zPosition = 10;
    [self.world addChild:barLeft];
    
    SKSpriteNode *barRight = [SKSpriteNode spriteNodeWithImageNamed:@"bar"];
    barRight.name = @"baro";
    barRight.position = CGPointMake(self.scene.frame.size.width/2 + barRight.size.width/2 - 10, self.currentBarY);
    barRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:barRight.size];
    barRight.physicsBody.dynamic = NO;
    barRight.physicsBody.categoryBitMask = barCategory;
    barRight.zPosition = 10;
    [self.world addChild:barRight];
    
    self.currentBarY = self.currentBarY - self.scene.frame.size.height;

}


-(void)generateNextLevel
{
    self.levelType = [self getRandomLevelType];
    if (self.levelType == 1) {
        [self generateLevel1];
    }
    if (self.levelType == 2) {
        [self generateLevel2];
    }
    if (self.levelType == 3) {
        [self generateLevel3];
    }
    if (self.levelType == 4) {
        [self generateLevel3];
    }
    if (self.levelType == 5) {
        [self generateLevel5];
    }
    if (self.levelType == 6) {
        [self generateLevel6];
    }
    
    self.enemyType = [self getRandomEnemy];
    if (self.enemyType == 1) {
        [self generateEnemy1];
    }
    if (self.enemyType == 2) {
        [self generateEnemy2];
    }
    
    

}


-(void)generateLevel1
{
    int randOpening = (arc4random() % ((int)(self.openingRange)));
    //SKSpriteNode *level1Left = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.scene.frame.size.width, 10)];
    SKSpriteNode *level1Left = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level1Left.name = @"level";
    level1Left.position = CGPointMake(0 - level1Left.size.width/2 - self.scene.frame.size.width/2 + 10 + randOpening, self.currentLevelY);
    level1Left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level1Left.size];
    level1Left.physicsBody.dynamic = NO;
    level1Left.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level1Left];
    
    //SKSpriteNode *level1Right = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.scene.frame.size.width, 10)];
    SKSpriteNode *level1Right = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level1Right.name = @"levelo";
    level1Right.position = CGPointMake(10 + randOpening + self.openingSize - self.scene.frame.size.width/2 + level1Right.size.width/2, self.currentLevelY);
    level1Right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level1Right.size];
    level1Right.physicsBody.dynamic = NO;
    level1Right.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level1Right];
    
    self.speedbarX = [self getRandomBarSpeed];
    
    if (self.speedbarX == 1) {
        SKSpriteNode *levelMoveLeftChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveLeftChecker.name = @"levelMoveLeft";
        levelMoveLeftChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveLeftChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 - 25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxLeft:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxLeftSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
        
    }
    
    if (self.speedbarX == 2) {
        SKSpriteNode *levelMoveRightChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveRightChecker.name = @"levelMoveRight";
        levelMoveRightChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveRightChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 -25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxRight:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxRightSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
    }

    

    self.currentLevelY = self.currentLevelY - self.levelInterval;

}

-(void)generateLevel2
{
    int randOpening = (arc4random() % ((int)(self.openingRange)));
    int randObs = (arc4random() % ((int)(self.openingRange - 2*self.obsSizeX)));
    if (randObs + self.obsSizeX > randOpening) {
        randObs = randObs + self.openingSize + self.obsSizeX;
    }
    
    SKSpriteNode *level2Left = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level2Left.name = @"level";
    level2Left.position = CGPointMake(0 - level2Left.size.width/2 - self.scene.frame.size.width/2 + 10 + randOpening, self.currentLevelY);
    level2Left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level2Left.size];
    level2Left.physicsBody.dynamic = NO;
    level2Left.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level2Left];
    
    SKSpriteNode *level2Right = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level2Right.name = @"levelo";
    level2Right.position = CGPointMake(10 + randOpening + self.openingSize - self.scene.frame.size.width/2 + level2Right.size.width/2, self.currentLevelY);
    level2Right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level2Right.size];
    level2Right.physicsBody.dynamic = NO;
    level2Right.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level2Right];
    
    SKSpriteNode *level2Obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level2Obstacle.name = @"levelobs";
    level2Obstacle.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level2Obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level2Obstacle.size];
    level2Obstacle.physicsBody.dynamic = NO;
    level2Obstacle.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level2Obstacle];
    
    self.speedbarX = [self getRandomBarSpeed];
    
    if (self.speedbarX == 1) {
        SKSpriteNode *levelMoveLeftChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveLeftChecker.name = @"levelMoveLeft";
        levelMoveLeftChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveLeftChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 - 25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxLeft:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxLeftSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
        
    }
    
    if (self.speedbarX == 2) {
        SKSpriteNode *levelMoveRightChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveRightChecker.name = @"levelMoveRight";
        levelMoveRightChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveRightChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 -25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxRight:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxRightSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
    }

    
    
    self.currentLevelY = self.currentLevelY - self.levelInterval;
}


-(void)generateLevel3
{
    int randOpening = (arc4random() % ((int)(self.openingRange)));
    int randObs1 = (arc4random() % ((int)(self.openingRange - 3*self.obsSizeX)));
    int randObs2 = (arc4random() % ((int)(self.openingRange - 3*self.obsSizeX)));
    
    while (abs(randObs1 - randObs2) < self.obsSizeX + 60) {
        randObs1 = (arc4random() % ((int)(self.openingRange - 3*self.obsSizeX)));
        randObs2 = (arc4random() % ((int)(self.openingRange - 3*self.obsSizeX)));
    }
    
    if (randObs1 + self.obsSizeX > randOpening) {
        randObs1 = randObs1 + self.openingSize + self.obsSizeX;
    }
    if (randObs2 + self.obsSizeX > randOpening) {
        randObs2 = randObs2 + self.openingSize + self.obsSizeX;
    }
    
    SKSpriteNode *level3Left = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level3Left.name = @"level";
    level3Left.position = CGPointMake(0 - level3Left.size.width/2 - self.scene.frame.size.width/2 + 10 + randOpening, self.currentLevelY);
    level3Left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level3Left.size];
    level3Left.physicsBody.dynamic = NO;
    level3Left.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level3Left];
    
    SKSpriteNode *level3Right = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level3Right.name = @"levelo";
    level3Right.position = CGPointMake(10 + randOpening + self.openingSize - self.scene.frame.size.width/2 + level3Right.size.width/2, self.currentLevelY);
    level3Right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level3Right.size];
    level3Right.physicsBody.dynamic = NO;
    level3Right.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level3Right];
    
    SKSpriteNode *level3Obstacle1 = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level3Obstacle1.name = @"levelobs";
    level3Obstacle1.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs1 + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level3Obstacle1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level3Obstacle1.size];
    level3Obstacle1.physicsBody.dynamic = NO;
    level3Obstacle1.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level3Obstacle1];
    
    SKSpriteNode *level3Obstacle2 = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level3Obstacle2.name = @"levelobs";
    level3Obstacle2.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs2 + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level3Obstacle2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level3Obstacle2.size];
    level3Obstacle2.physicsBody.dynamic = NO;
    level3Obstacle2.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level3Obstacle2];
    
    self.speedbarX = [self getRandomBarSpeed];
    
    if (self.speedbarX == 1) {
        SKSpriteNode *levelMoveLeftChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveLeftChecker.name = @"levelMoveLeft";
        levelMoveLeftChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveLeftChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 - 25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxLeft:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxLeftSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
        
    }
    
    if (self.speedbarX == 2) {
        SKSpriteNode *levelMoveRightChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveRightChecker.name = @"levelMoveRight";
        levelMoveRightChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveRightChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 -25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxRight:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxRightSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
    }
    
    
    
    self.currentLevelY = self.currentLevelY - self.levelInterval;
}


-(void)generateLevel4
{
    int randOpening = (arc4random() % ((int)(self.openingRange)));
    int randObs1 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
    int randObs2 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
    int randObs3 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
    
    while (abs(randObs1 - randObs2) < self.obsSizeX + 10 && abs(randObs2 - randObs3) < self.obsSizeX + 10 && abs(randObs1 - randObs3) < self.obsSizeX + 10) {
        randObs1 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
        randObs2 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
        randObs3 = (arc4random() % ((int)(self.openingRange - 4*self.obsSizeX)));
    }
    
    if (randObs1 + self.obsSizeX > randOpening) {
        randObs1 = randObs1 + self.openingSize + self.obsSizeX;
    }
    if (randObs2 + self.obsSizeX > randOpening) {
        randObs2 = randObs2 + self.openingSize + self.obsSizeX;
    }
    if (randObs3 + self.obsSizeX > randOpening) {
        randObs3 = randObs3 + self.openingSize + self.obsSizeX;
    }
    
    SKSpriteNode *level4Left = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level4Left.name = @"level";
    level4Left.position = CGPointMake(0 - level4Left.size.width/2 - self.scene.frame.size.width/2 + 10 + randOpening, self.currentLevelY);
    level4Left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level4Left.size];
    level4Left.physicsBody.dynamic = NO;
    level4Left.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level4Left];
    
    SKSpriteNode *level4Right = [SKSpriteNode spriteNodeWithImageNamed:@"platform20"];
    level4Right.name = @"levelo";
    level4Right.position = CGPointMake(10 + randOpening + self.openingSize - self.scene.frame.size.width/2 + level4Right.size.width/2, self.currentLevelY);
    level4Right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level4Right.size];
    level4Right.physicsBody.dynamic = NO;
    level4Right.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level4Right];
    
    SKSpriteNode *level4Obstacle1 = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level4Obstacle1.name = @"levelobs";
    level4Obstacle1.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs1 + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level4Obstacle1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level4Obstacle1.size];
    level4Obstacle1.physicsBody.dynamic = NO;
    level4Obstacle1.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level4Obstacle1];
    
    SKSpriteNode *level4Obstacle2 = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level4Obstacle2.name = @"levelobs";
    level4Obstacle2.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs2 + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level4Obstacle2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level4Obstacle2.size];
    level4Obstacle2.physicsBody.dynamic = NO;
    level4Obstacle2.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level4Obstacle2];
    
    SKSpriteNode *level4Obstacle3 = [SKSpriteNode spriteNodeWithImageNamed:@"obs20"];
    level4Obstacle3.name = @"levelobs";
    level4Obstacle3.position = CGPointMake(0 - self.scene.frame.size.width/2 + 10 + randObs3 + self.obsSizeX/2, self.currentLevelY + self.obsSizeY/2);
    level4Obstacle3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level4Obstacle3.size];
    level4Obstacle3.physicsBody.dynamic = NO;
    level4Obstacle3.physicsBody.categoryBitMask = obsCategory;
    [self.world addChild:level4Obstacle3];
    
    self.speedbarX = [self getRandomBarSpeed];
    
    if (self.speedbarX == 1) {
        SKSpriteNode *levelMoveLeftChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveLeftChecker.name = @"levelMoveLeft";
        levelMoveLeftChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveLeftChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 - 25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxLeft:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxLeftSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
        
    }
    
    if (self.speedbarX == 2) {
        SKSpriteNode *levelMoveRightChecker = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        levelMoveRightChecker.name = @"levelMoveRight";
        levelMoveRightChecker.position = CGPointMake(0 - self.scene.frame.size.width, self.currentLevelY);
        [self.world addChild:levelMoveRightChecker];
        
        int boxNumberLeft = floor(randOpening/20);
        int boxNumberRight = floor(self.scene.frame.size.width - 20 - randOpening - self.openingSize)/20;
        float max = 0;
        float min = 0;
        max = boxNumberLeft * 20 + 5;
        min = self.scene.frame.size.width - boxNumberRight * 20 - 5;
        float boxStartingPositionLeft = 25 - self.scene.frame.size.width/2;
        float boxStartingPositionRight = self.scene.frame.size.width/2 -25;
        for (int i = 0; i < boxNumberLeft; i++) {
            [self generateMovingBoxRight:CGPointMake(boxStartingPositionLeft, max)];
            boxStartingPositionLeft = boxStartingPositionLeft + 20;
        }
        for (int j = 0; j < boxNumberRight; j++) {
            [self generateMovingBoxRightSecondBar:CGPointMake(boxStartingPositionRight, min)];
            boxStartingPositionRight = boxStartingPositionRight - 20;
        }
    }
    
    
    
    self.currentLevelY = self.currentLevelY - self.levelInterval;

    
}


-(void)generateLevel5
{
    self.level5sizeX = arc4random() % 50 + 50;
    self.level5sizeX = 50;
    int level5range = (int)(self.scene.frame.size.width - 20 - self.level5sizeX);
    self.level5startX = arc4random() % level5range + 10;
    //self.level5startX = self.scene.frame.size.width/2 - 20;
    SKSpriteNode *level5bar = [SKSpriteNode spriteNodeWithImageNamed:@"platform20_100"];
    level5bar.name = @"level5";
    level5bar.position = CGPointMake(self.level5startX + self.level5sizeX/2 - self.scene.frame.size.width/2, self.currentLevelY);
    level5bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level5bar.size];
    level5bar.physicsBody.dynamic = NO;
    level5bar.physicsBody.categoryBitMask = levelCategory;
    [self.world addChild:level5bar];
    
    SKSpriteNode *level5checker = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    level5checker.name = @"level";
    level5checker.position = CGPointMake(self.scene.frame.size.width + 1, self.currentLevelY);
    [self.world addChild:level5checker];
    
    self.level5item = [self getRandomItem];
    if (self.level5item == 1) {
        SKSpriteNode *slowMotionItem = [SKSpriteNode spriteNodeWithImageNamed:@"clock30"];
        slowMotionItem.name = @"slowMotionItem";
        slowMotionItem.position = CGPointMake(level5bar.position.x, level5bar.position.y + 25);
        [self.world addChild:slowMotionItem];
    }
    if (self.level5item == 2) {
        SKSpriteNode *shieldItem = [SKSpriteNode spriteNodeWithImageNamed:@"shield30"];
        shieldItem.name = @"shieldItem";
        shieldItem.position = CGPointMake(level5bar.position.x, level5bar.position.y + 25);
        [self.world addChild:shieldItem];
    }
    if (self.level5item == 3) {
        SKSpriteNode *fieldItem = [SKSpriteNode spriteNodeWithImageNamed:@"banana30"];
        fieldItem.name = @"fieldItem";
        fieldItem.position = CGPointMake(level5bar.position.x, level5bar.position.y + 25);
        [self.world addChild:fieldItem];
    }
    
    
    
    self.currentLevelY = self.currentLevelY - self.levelInterval;
}


-(void)generateLevel6
{
    /*self.level6sizeX = 150;
    SKSpriteNode *level6bar = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.level6sizeX, 10)];
    level6bar.name = @"level6";
    level6bar.position = CGPointMake(10 - self.scene.frame.size.width/2 + self.level6sizeX/2, self.currentLevelY);
    level6bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level6bar.size];
    level6bar.physicsBody.dynamic = NO;
    level6bar.physicsBody.categoryBitMask = level6Category;
    [self.world addChild:level6bar];
     */
    self.level6sizeX = 150;
    self.level6speedX = ((float)(arc4random() % 10) + 1)/2;
    //self.level6speedX = 0.05;
    HWLevel6 *level6bar = [HWLevel6 level6:self.level6speedX];
    level6bar.position = CGPointMake(10 - self.scene.frame.size.width/2 + level6bar.size.width/2, self.currentLevelY);
    level6bar.name = @"level6MoveRight";
    level6bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:level6bar.size];
    level6bar.physicsBody.dynamic = NO;
    level6bar.physicsBody.categoryBitMask = level6Category;
    [self.world addChild:level6bar];
    
    SKSpriteNode *level6checker = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    level6checker.name = @"level";
    level6checker.position = CGPointMake(self.scene.frame.size.width + 1, self.currentLevelY);
    [self.world addChild:level6checker];

    
    //[self level6Movement:level6bar];
    
    
    self.currentLevelY = self.currentLevelY - self.levelInterval;
}



-(void)fillLevel1
{
    for (int i = 0; i < 10; i++) {
        [self generateNextLevel];
    }
}


-(void)generateMovingBoxLeft:(CGPoint)boxXandStartX
//boxXandStartX is not an actual point on the game, but passing two arguements to generateMovingBox funtion
//boxXandStarX.x is the starting point of the box when it first appears and boxXandStartX is where is it gonna appear once it reached the side and regenerate on the other side.
{
    HWMovingBars *movingBars = [HWMovingBars movingBars:boxXandStartX.y];
    movingBars.name = @"movingBoxLeft";
    movingBars.position = CGPointMake(boxXandStartX.x, self.currentLevelY);
    [self.world addChild:movingBars];

    
}



-(void)generateMovingBoxLeftSecondBar:(CGPoint)boxXandEndX
{
    HWMovingBars *movingBars = [HWMovingBars movingBars:boxXandEndX.y];
    movingBars.name = @"movingBoxLeftSecondBar";
    movingBars.position = CGPointMake(boxXandEndX.x, self.currentLevelY);
    [self.world addChild:movingBars];
    
}


-(void)generateMovingBoxRight:(CGPoint)boxXandEndX
{
    HWMovingBars *movingBars = [HWMovingBars movingBars:boxXandEndX.y];
    movingBars.name = @"movingBoxRight";
    movingBars.position = CGPointMake(boxXandEndX.x, self.currentLevelY);
    [movingBars mirror];
    [self.world addChild:movingBars];
}

-(void)generateMovingBoxRightSecondBar:(CGPoint)boxXandStartX
{
    HWMovingBars *movingBars = [HWMovingBars movingBars:boxXandStartX.y];
    movingBars.name = @"movingBoxRightSecondBar";
    movingBars.position = CGPointMake(boxXandStartX.x, self.currentLevelY);
    [movingBars mirror];
    [self.world addChild:movingBars];
    
}


-(void)generateEnemy1
{
    float tempEnemy1Speed = [self getRandomEnemy1Speed];
    HWFastEnemy *fastEnemy = [HWFastEnemy generateEnemy:tempEnemy1Speed];
    float fastEnemyStartX = (arc4random() % (int)(self.scene.frame.size.width - 20)) - self.scene.frame.size.width/2;
    fastEnemy.position = CGPointMake(fastEnemyStartX, self.currentLevelY + 20);
    fastEnemy.name = @"enemy1MoveRight";
    
    [self.world addChild:fastEnemy];
}

-(void)generateEnemy2
{
    float tempEnemy1Speed = [self getRandomEnemy1Speed];
    HWFastEnemy *fastEnemy = [HWFastEnemy generateEnemy:tempEnemy1Speed];
    float fastEnemyStartX = (arc4random() % (int)(self.scene.frame.size.width - 20)) - self.scene.frame.size.width/2;
    fastEnemy.position = CGPointMake(fastEnemyStartX, self.currentLevelY + 20);
    fastEnemy.name = @"enemy2MoveRight";
    fastEnemy.texture = [SKTexture textureWithImageNamed:@"skull30"];
    
    [self.world addChild:fastEnemy];
}

-(void)generateEnemy3
{
    
}




-(void)boxMovingLeft:(SKSpriteNode *)node
{
    SKAction *incrementLeft = [SKAction moveByX:-1.0 y:0 duration:0.005];
    [node runAction:incrementLeft];
}


-(void)boxMOvingRight:(SKSpriteNode *)node
{
    SKAction *incrementRight = [SKAction moveByX:1.0 y:0 duration:0.005];
    [node runAction:incrementRight];
}


-(void)Level6WithSpeedP:(HWLevel6 *)node
{
    SKAction *moveRight = [SKAction moveByX:node.barSpeed y:0 duration:0.005];
    [node runAction:moveRight];
    
}

-(void)Level6WithSpeedN:(HWLevel6 *)node
{
    SKAction *moveLeft = [SKAction moveByX:-node.barSpeed y:0 duration:0.005];
    [node runAction:moveLeft];
    
}

-(void)enemy1MoveRight:(HWFastEnemy *)node
{
    SKAction *moveRight = [SKAction moveByX:node.SpeedOfEnemy y:0 duration:0.005];
    [node runAction:moveRight];
}

-(void)enemy1MoveLeft:(HWFastEnemy *)node
{
    SKAction *moveLeft = [SKAction moveByX:-node.SpeedOfEnemy y:0 duration:0.005];
    [node runAction:moveLeft];
}


-(void)hellStartMoving
{
    SKAction *incrementDown = [SKAction moveByX:0 y:self.worldSpeed duration:0.03];
    SKAction *moveDown = [SKAction repeatActionForever:incrementDown];
    [self.world runAction:moveDown];
}

-(void)hellSpeedUp
{
    SKAction *incrementDown = [SKAction moveByX:0 y:2.5 duration:0.03];
    SKAction *moveDown = [SKAction repeatAction:incrementDown count:300];
    [self.world runAction:moveDown];
    //self.currentSpeed = self.currentSpeed + 1;
    
}


-(void)hellSlowDown
{

    SKAction *incrementUp = [SKAction moveByX:0 y:-2 duration:0.03];
    SKAction *moveUp = [SKAction repeatAction:incrementUp count:300];
    [self.world runAction:moveUp];
    //self.currentSpeed = self.currentSpeed - 1;

    
}

-(void)hellCrush
{
    [self.world removeAllActions];
    SKAction *incrementDown = [SKAction moveByX:0 y:0.55 duration:0.03];
    SKAction *crush = [SKAction repeatAction:incrementDown count:70];
    [self.world runAction:crush];
}

-(void)hellStop
{
    [self.world removeAllActions];
}



-(int)getRandomLevelType
{
    int randLevelType = arc4random() % 6 + 1;
    return randLevelType;
}


-(int)getRandomBarSpeed
{
    int randBarSpeed = arc4random() % 5;
    if (randBarSpeed > 2) {
        randBarSpeed = 0;
    }
    return randBarSpeed;
}

-(int)getRandomItem
{
    int randItem = arc4random() % 4;
    //randItem = 1;
    return randItem;
}

-(int)getRandomEnemy
{
    int randEnemy = arc4random() % 10;
    return randEnemy;
}

-(float)getRandomEnemy1Speed
{
    float randEnemySpeed = (float)(arc4random() % 20)/10 + 1;
    return randEnemySpeed;
}


-(void)blood:(CGPoint)bloodXY
{
    //int bloodx = arc4random() % 200 - 100;
    //int bloody = arc4random() % 200 - 100;
    SKSpriteNode *blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood"];
    blood.position = CGPointMake(bloodXY.x, bloodXY.y);
    blood.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blood.size];
    [blood.physicsBody applyImpulse:CGVectorMake(0, 20)];
    [self addChild:blood];
}

-(void)speedUpSign
{
    SKSpriteNode *SUS = [SKSpriteNode spriteNodeWithImageNamed:@"speedup400"];
    [SUS setSize:CGSizeMake(self.scene.frame.size.width * 2/3, self.scene.frame.size.height * 2/3)];
    SUS.position = CGPointMake(0, 0);
    SUS.alpha = 0.0;
    SUS.zPosition = -5;
    [self addChild:SUS];
    [self animateWithPulse:SUS];
}

-(void)slowDownSign
{
    SKSpriteNode *SDS = [SKSpriteNode spriteNodeWithImageNamed:@"slowdown"];
    [SDS setSize:CGSizeMake(self.scene.frame.size.width, self.scene.frame.size.height)];
    SDS.position = CGPointMake(0, 0);
    SDS.alpha = 0.0;
    SDS.zPosition = -5;
    [self addChild:SDS];
    [self animateWithPulse:SDS];
}

-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:0.7 duration:0.4];
    SKAction *pulse = [SKAction sequence:@[appear, disappear]];
    [node runAction:[SKAction repeatAction:pulse count:9]];
}

-(void)animateSlowDown:(SKNode *)node
{
    
}


@end
