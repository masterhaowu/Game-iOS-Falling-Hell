//
//  GameScene.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/21/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "GameScene.h"
#import "HWDude.h"
#import "HWHellGenerator.h"
#import "HWMovingBars.h"
#import "HWLevel6.h"
#import "HWFastEnemy.h"
#import "HWLabels.h"
#import "HWGameData.h"

#define HWUpdateInterval (1.0f/60.0f)


@interface GameScene ()

@property float dudeVelocity;
@property BOOL gameStarted;
@property BOOL gameOvered;
@property BOOL inAir;
@property float levelInterval;
@property int score;
@property float backR;
@property float backG;
@property float backB;
@property int springLevel;
@property int onLevel6; // 0 means not on Level 6, 1 means first touch Level 6, 2 means stays on Level 6
@property BOOL fieldOn;
@property float pevData;
@property int moveCheck;



@end

@implementation GameScene
{
    HWDude *dude;
    HWHellGenerator *generator;
    SKNode *world;
    SKSpriteNode *dudeD1;
    SKSpriteNode *dudeD2;
    SKSpriteNode *dudeD3;
    SKSpriteNode *dudeD4;
    SKSpriteNode *buttom;
    SKSpriteNode *buttomWall;
    SKSpriteNode *buttomWall2;
    SKSpriteNode *springUp;
    SKSpriteNode *weight1;
    SKSpriteNode *weight2;
    SKSpriteNode *field;
    NSTimer* dieTimer;
    NSTimer* dieTimer2;
    NSTimer* dieTimer3;
    
}

static NSString *GAME_FONT = @"americanTypewriter-Bold";
//static const uint32_t dudeCategory = 0x1 << 0;
//static const uint32_t topCategory = 0x1 << 1;
static const uint32_t levelCategory = 0x1 << 2;
//static const uint32_t barCategory = 0x1 << 3;
//static const uint32_t levelCategory = 0x1 << 2;

-(void)didMoveToView:(SKView *)view
{

    /* Setup your scene here */
    self.backR = 0.90;
    self.backG = 0.90;
    self.backB = 0.90;
    self.backgroundColor = [SKColor colorWithRed:self.backR green:self.backG blue:self.backB alpha:1.0];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.physicsWorld.contactDelegate = self;
    self.dudeVelocity = 0;
    self.gameStarted = NO;
    self.gameOvered = NO;
    self.inAir = NO;
    self.levelInterval = 130;
    self.onLevel6 = 0;
    self.springLevel = 0;
    self.fieldOn = NO;
    self.pevData = 0.3;
    self.moveCheck = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];

    world = [SKNode node];
    [self addChild:world];
    
    dude = [HWDude dude];
    [world addChild:dude];
    
    //[dude walking];
    
    dudeD1 = [SKSpriteNode spriteNodeWithImageNamed:@"guyD1"];
    dudeD2 = [SKSpriteNode spriteNodeWithImageNamed:@"guyD2"];
    dudeD3 = [SKSpriteNode spriteNodeWithImageNamed:@"guyD3"];
    dudeD4 = [SKSpriteNode spriteNodeWithImageNamed:@"guyD4"];
    [world addChild:dudeD1];
    [world addChild:dudeD2];
    [world addChild:dudeD3];
    [world addChild:dudeD4];
    dudeD1.hidden = YES;
    dudeD2.hidden = YES;
    dudeD3.hidden = YES;
    dudeD4.hidden = YES;
    
    SKSpriteNode *startInfo = [SKSpriteNode spriteNodeWithImageNamed:@"startinfo"];
    startInfo.position = CGPointMake(0, -10);
    startInfo.name = @"startInfo";
    startInfo.zPosition = 10;
    [self addChild:startInfo];
    [self animateForever:startInfo];
    
    generator = [HWHellGenerator generatorWithWorld:world];
    [self addChild:generator];
    
    //SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    //tapToBeginLabel.text = @"TAP TO BEGIN";
    //tapToBeginLabel.name = @"tapToBegin";
    //tapToBeginLabel.fontSize = 32.0;
    //[self addChild:tapToBeginLabel];
    SKSpriteNode *tapToBegin = [SKSpriteNode spriteNodeWithImageNamed:@"taptostart"];
    tapToBegin.size = CGSizeMake(self.scene.frame.size.width, self.scene.frame.size.width/3);
    tapToBegin.position = CGPointMake(0, self.scene.frame.size.height/6);
    tapToBegin.name = @"tapToBegin";
    [self addChild:tapToBegin];
    
    [self scoresAndLabels];
    
    [generator generateBars];
    //[generator generateTop];
    [generator initialize];
    
    buttom = [SKSpriteNode spriteNodeWithImageNamed:@"nail_m"];
    buttom.position = CGPointMake(0, -self.scene.frame.size.height/2 - buttom.size.height/2);
    [self addChild:buttom];
    
    buttomWall = [SKSpriteNode spriteNodeWithImageNamed:@"spring"];
    buttomWall.position = CGPointMake(-self.scene.frame.size.width/4, -self.scene.frame.size.height/2 - buttomWall.size.height/2);
    [self addChild:buttomWall];
    
    buttomWall2 = [SKSpriteNode spriteNodeWithImageNamed:@"spring"];
    buttomWall2.position = CGPointMake(self.scene.frame.size.width/4, -self.scene.frame.size.height/2 - buttomWall2.size.height/2);
    [self addChild:buttomWall2];
    
    weight1 = [SKSpriteNode spriteNodeWithImageNamed:@"weight"];
    weight1.position = CGPointMake(-self.scene.frame.size.width/4, -self.scene.frame.size.height/2 + buttom.size.height + weight1.size.height/2);
    weight1.alpha = 0.0;
    [self addChild:weight1];
    
    weight2 = [SKSpriteNode spriteNodeWithImageNamed:@"weight"];
    weight2.position = CGPointMake(self.scene.frame.size.width/4, -self.scene.frame.size.height/2 + buttom.size.height + weight2.size.height/2);
    weight2.alpha = 0.0;
    [self addChild:weight2];
    
    springUp = [SKSpriteNode spriteNodeWithImageNamed:@"springup"];
    springUp.position = CGPointMake(0, -self.scene.frame.size.height/2 + springUp.size.height/2);
    springUp.alpha = 0;
    [self addChild:springUp];
    
    field = [SKSpriteNode spriteNodeWithImageNamed:@"field"];
    field.position = CGPointMake(0, -self.scene.frame.size.height/2 + 10 + self.scene.frame.size.height);
    field.alpha = 0;
    field.name = @"field";
    field.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:field.size];
    field.physicsBody.dynamic = NO;
    field.physicsBody.categoryBitMask = levelCategory;
    field.zPosition = 1;
    [self addChild:field];
   


}


-(void)gameStart
{
    [dude walking:0.05];
    [generator generateTop];
    SKAction *incrementUp = [SKAction moveByX:0 y:0.5 duration:0.03];
    SKAction *moveUp = [SKAction repeatAction:incrementUp count:40];
    [buttom runAction:moveUp];
    [[self childNodeWithName:@"tapToBegin"] removeFromParent];
    [[self childNodeWithName:@"startInfo"] removeFromParent];
    self.gameStarted = YES;
    [generator hellStartMoving];
    self.lastUpdateTime = [[NSDate alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager startAccelerometerUpdates];
    self.pevData = 0.3;
    
}




-(void)gameOverTop
{
    self.gameOvered = YES;
    [generator hellCrush];
    [self dieTop1];
}

-(void)dieTop1
{

    dudeD1.position = CGPointMake(dude.position.x, dude.position.y - 5);
    dudeD2.position = CGPointMake(dude.position.x, dude.position.y - 8);
    dudeD3.position = CGPointMake(dude.position.x, dude.position.y - 12);
    dudeD4.position = CGPointMake(dude.position.x, dude.position.y - 15);
    
    dude.hidden = YES;
    [dude removeFromParent];
    dudeD1.hidden = NO;
    dieTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dieTop2) userInfo:nil repeats:NO];
    
}


-(void)dieTop2
{
    
    dudeD1.hidden = YES;
    dudeD2.hidden = NO;
    dieTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dieTop3) userInfo:nil repeats:NO];
}

-(void)dieTop3
{

    dudeD2.hidden = YES;
    dudeD3.hidden = NO;
    dieTimer3 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dieTop4) userInfo:nil repeats:NO];
}

-(void)dieTop4
{

    dudeD3.hidden = YES;
    dudeD4.hidden = NO;
    [self gameOver];
}


-(void)gameOverButtom
{
    self.gameOvered = YES;
    dude.physicsBody.affectedByGravity = NO;
    [generator hellStop];
    [self dieTop1];
}

-(void)gameOver
{
    [generator hellStop];
    [self updateHighScore];
    self.gameOvered = YES;
    
    SKSpriteNode *gameOverLabel = [SKSpriteNode spriteNodeWithImageNamed:@"gameover"];
    gameOverLabel.size = CGSizeMake(self.scene.frame.size.width, self.scene.frame.size.width/3);
    gameOverLabel.position = CGPointMake(0, self.scene.frame.size.height/4);
    gameOverLabel.zPosition = 10;
    [self addChild:gameOverLabel];
    [self animateForever:gameOverLabel];
    
    SKSpriteNode *tapToResetLabel = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
    tapToResetLabel.size = CGSizeMake(self.scene.frame.size.width, self.scene.frame.size.width/2);
    tapToResetLabel.position = CGPointMake(0, 0);
    tapToResetLabel.name = @"tapToReset";
    tapToResetLabel.zPosition = 10;
    [self addChild:tapToResetLabel];
    [self animateForever:tapToResetLabel];

}


-(void)restart{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}



- (void)tap:(UITapGestureRecognizer *)gesture{

    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (!self.gameStarted) {
            [self gameStart];
        }
        else if(self.gameOvered == YES){
            [self restart];
        }
        else if(self.inAir == NO){
            [dude jump];
            self.inAir = YES;
        }
    }
}



-(void)didSimulatePhysics
{
    if (self.gameOvered == NO) {
        //[self checkMoving];
        [self moreBars];
        [self generateLevels];
        [self checkFalling];
        //dude.pevDudeY = dude.position.y;
    }

    //[self updateBackground];
}

-(void)checkMoving
{
    if (self.moveCheck == 1) {
        [dude walking:0.05];
        self.moveCheck = 2;
    }
    
}

-(void)checkFalling
{
    
    if ([dude intersectsNode:buttom]==YES && self.gameOvered == NO) {
        [self gameOverButtom];
    }
}


-(void)moreBars
{
    [world enumerateChildNodesWithName:@"bar" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y > dude.position.y - self.scene.frame.size.height) {
            node.name = @"barPassed";
            [generator generateBars];
        }
    }];
}


-(void)generateLevels
{
    [world enumerateChildNodesWithName:@"level" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y + self.scene.frame.size.height/2 > dude.position.y && self.gameOvered == NO) {
            node.name = @"level_checked";
            [generator generateNextLevel];
        }
    }];
    
    
    [world enumerateChildNodesWithName:@"level_checked" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y > dude.position.y) {
            node.name = @"level_passed";
            HWLabels *pointsLabel = (HWLabels *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
            //[self updateBackground];

        }
    }];
    
    [world enumerateChildNodesWithName:@"levelMoveLeft" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y + 1 < dude.position.y && node.position.y + 40 > dude.position.y) {
            [dude moveLeft];
        }
    }];
    
    [world enumerateChildNodesWithName:@"levelMoveRight" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y + 1 < dude.position.y && node.position.y + 40 > dude.position.y) {
            [dude moveRight];
        }
    }];
    
    [world enumerateChildNodesWithName:@"movingBoxLeft" usingBlock:^(SKNode *node, BOOL *stop) {
        HWMovingBars *movingBars = (HWMovingBars *)node;
        if (node.position.x < 16 - self.scene.frame.size.width/2) {
            node.position = CGPointMake(movingBars.startPosition + 10 - self.scene.frame.size.width/2, node.position.y);
            [movingBars fadeIn:(SKSpriteNode *)node];
        }
        if (node.position.x < 26 - self.scene.frame.size.width/2) {
            [movingBars fadeOut:(SKSpriteNode *)node];
        }
        [generator boxMovingLeft:(SKSpriteNode *)(node)];
    }];
    
    [world enumerateChildNodesWithName:@"movingBoxLeftSecondBar" usingBlock:^(SKNode *node, BOOL *stop) {
        HWMovingBars *movingBars = (HWMovingBars *)node;
        if (node.position.x < movingBars.startPosition - 9 - self.scene.frame.size.width/2) {
            node.position = CGPointMake(self.scene.frame.size.width/2 - 15, node.position.y);
            [movingBars fadeIn:(SKSpriteNode *)node];
        }
        if (node.position.x < movingBars.startPosition - self.scene.frame.size.width/2) {
            [movingBars fadeOut:(SKSpriteNode *)node];
        }
        [generator boxMovingLeft:(SKSpriteNode *)(node)];
    }];
    
    [world enumerateChildNodesWithName:@"movingBoxRight" usingBlock:^(SKNode *node, BOOL *stop) {
        HWMovingBars *movingBars = (HWMovingBars *)node;
        if (node.position.x > movingBars.startPosition + 9 - self.scene.frame.size.width/2) {
            node.position = CGPointMake(15 - self.scene.frame.size.width/2, node.position.y);
            [movingBars fadeIn:(SKSpriteNode *)node];
        }
        //now try the fade in fade out effect after this
        if (node.position.x > movingBars.startPosition - self.scene.frame.size.width/2) {
            [movingBars fadeOut:(SKSpriteNode *)node];
        }

    
        [generator boxMOvingRight:(SKSpriteNode *)(node)];
        
    }];
    
    [world enumerateChildNodesWithName:@"movingBoxRightSecondBar" usingBlock:^(SKNode *node, BOOL *stop) {
        HWMovingBars *movingBars = (HWMovingBars *)node;
        if (node.position.x > self.scene.frame.size.width/2 - 16) {
            node.position = CGPointMake(movingBars.startPosition - 10  - self.scene.frame.size.width/2, node.position.y);
            [movingBars fadeIn:(SKSpriteNode *)node];
        }
        if (node.position.x > self.scene.frame.size.width/2 - 26) {
            [movingBars fadeOut:(SKSpriteNode *)node];
        }
        [generator boxMOvingRight:(SKSpriteNode *)(node)];
    }];
    
    
    //now deal with level6 to make sure the dude moves with the level6 bar
    [world enumerateChildNodesWithName:@"level6MoveRight" usingBlock:^(SKNode *node, BOOL *stop) {
        HWLevel6 *barLevel6 = (HWLevel6 *)node;
        [generator Level6WithSpeedP:barLevel6];
        if (node.position.x > self.scene.frame.size.width/2 - 10 - node.frame.size.width/2) {
            node.name = @"level6MoveLeft";
        }
        if (node.position.y + dude.size.height/2 + 16 > dude.position.y && node.position.y + dude.size.height/2 + 1 < dude.position.y && self.onLevel6 == 1) {
            barLevel6.onMe = YES;
            self.onLevel6 = 0;
            [dude moveOnLevel6WithSpeedP:barLevel6.barSpeed];
        }
        if (node.position.y + dude.size.height/2 + 16 > dude.position.y && node.position.y + dude.size.height/2 + 1 < dude.position.y && barLevel6.onMe == YES) {
            //barLevel6.onMe = YES;
            //self.onLevel6 = 0;
            [dude moveOnLevel6WithSpeedP:barLevel6.barSpeed];
        }
        else {
            barLevel6.onMe = NO;
        }
    }];
    [world enumerateChildNodesWithName:@"level6MoveLeft" usingBlock:^(SKNode *node, BOOL *stop) {
        HWLevel6 *barLevel6 = (HWLevel6 *)node;
        [generator Level6WithSpeedN:barLevel6];
        if (node.position.x < 10 + node.frame.size.width/2 - self.scene.frame.size.width/2) {
            node.name = @"level6MoveRight";
        }
        if (node.position.y + dude.size.height/2 + 16 > dude.position.y && node.position.y + dude.size.height/2 + 1 < dude.position.y && self.onLevel6 == 1) {
            barLevel6.onMe = YES;
            self.onLevel6 = 0;
            [dude moveOnLevel6WithSpeedN:barLevel6.barSpeed];
        }
        if (node.position.y + dude.size.height/2 + 16 > dude.position.y && node.position.y + dude.size.height/2 + 1 < dude.position.y && barLevel6.onMe == YES) {
            //barLevel6.onMe = YES;
            //self.onLevel6 = 0;
            [dude moveOnLevel6WithSpeedN:barLevel6.barSpeed];
        }
        else {
            barLevel6.onMe = NO;
        }
    }];
    
    //now deal with level 5 items
    [world enumerateChildNodesWithName:@"slowMotionItem" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([dude intersectsNode:node]) {
            [generator hellSlowDown];
            [generator slowDownSign];
            node.name = @"slowMotionItem_got";
            [node removeFromParent];
        }
    }];
    [world enumerateChildNodesWithName:@"shieldItem" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([dude intersectsNode:node]) {
            [self getShield];
            node.name = @"shieldItem_got";
            [node removeFromParent];
        }
    }];
    [world enumerateChildNodesWithName:@"fieldItem" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([dude intersectsNode:node]) {
            [self getDoubleField];
            node.name = @"fieldItem_got";
            [node removeFromParent];
        }
    }];

    
    //enemy1
    [world enumerateChildNodesWithName:@"enemy1MoveRight" usingBlock:^(SKNode *node, BOOL *stop) {
        HWFastEnemy *fastEnemy = (HWFastEnemy *)node;
        [generator enemy1MoveRight:fastEnemy];
        if (node.position.x > self.scene.frame.size.width/2 - 16) {
            node.name = @"enemy1MoveLeft";
        }
        if ([dude intersectsNode:node]) {
            [generator hellSpeedUp];
            node.name = @"enemy_hit";
            [generator speedUpSign];
        }
    }];
    [world enumerateChildNodesWithName:@"enemy1MoveLeft" usingBlock:^(SKNode *node, BOOL *stop) {
        HWFastEnemy *fastEnemy = (HWFastEnemy *)node;
        [generator enemy1MoveLeft:fastEnemy];
        if (node.position.x < 16 - self.scene.frame.size.width/2) {
            node.name = @"enemy1MoveRight";
        }
        if ([dude intersectsNode:node]) {
            [generator hellSpeedUp];
            node.name = @"enemy_hit";
            [generator speedUpSign];
        }
    }];
    //enemy2
    [world enumerateChildNodesWithName:@"enemy2MoveRight" usingBlock:^(SKNode *node, BOOL *stop) {
        HWFastEnemy *fastEnemy = (HWFastEnemy *)node;
        [generator enemy1MoveRight:fastEnemy];
        if (node.position.x > self.scene.frame.size.width/2 - 16) {
            node.name = @"enemy2MoveLeft";
        }
        if ([dude intersectsNode:node]) {
            [self getSkull];
            node.name = @"enemy_hit";
            //[generator speedUpSign];
        }
    }];
    [world enumerateChildNodesWithName:@"enemy2MoveLeft" usingBlock:^(SKNode *node, BOOL *stop) {
        HWFastEnemy *fastEnemy = (HWFastEnemy *)node;
        [generator enemy1MoveLeft:fastEnemy];
        if (node.position.x < 16 - self.scene.frame.size.width/2) {
            node.name = @"enemy2MoveRight";
        }
        if ([dude intersectsNode:node]) {
            [self getSkull];
            node.name = @"enemy_hit";
            //[generator speedUpSign];
        }
    }];

    
    
    
    [world enumerateChildNodesWithName:@"enemy_hit" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"field" usingBlock:^(SKNode *node, BOOL *stop) {
        /*if (node.position.y + 50 < dude.position.y && self.fieldOn == YES) {
            NSLog(@"called");
            field.position = CGPointMake(0, self.scene.frame.size.height + 10);
            SKAction *disappear = [SKAction fadeAlphaTo:1 duration:0.5];
            self.fieldOn = NO;
            [field runAction:disappear];
        }*/
        if (node.position.y + 50 < dude.position.y) {
            NSLog(@"called");
        }
    }];

    

    
}



//for motion
-(void)processUserMotionForUpdate:(NSTimeInterval)currentTime {
        CMAccelerometerData* data = self.motionManager.accelerometerData;
    if (fabs(data.acceleration.x) > 0.2 && self.gameOvered == NO) {
        /*if (data.acceleration.x > 0) {
            [dude setTexture:[SKTexture textureWithImageNamed:@"guy"]];
            //dude.physicsBody = [SKPhysicsBody bodyWithTexture:dude.texture size:dude.size];
        }
        else{
            [dude setTexture:[SKTexture textureWithImageNamed:@"guy_m"]];
 
            //dude.physicsBody = [SKPhysicsBody bodyWithTexture:dude.texture size:dude.size];
        }*/
        
        if (data.acceleration.x > 0 && self.pevData < - 0.2) {
            //[dude setTexture:[SKTexture textureWithImageNamed:@"guy_m"]];
            //dude.physicsBody = [SKPhysicsBody bodyWithTexture:dude.texture size:dude.size];
            dude.xScale = dude.xScale * -1;
            dudeD1.xScale = dudeD1.xScale * -1;
            dudeD2.xScale = dudeD2.xScale * -1;
            dudeD3.xScale = dudeD3.xScale * -1;
            dudeD4.xScale = dudeD4.xScale * -1;
        }
        if (data.acceleration.x < 0 && self.pevData > 0.2) {
            //[dude setTexture:[SKTexture textureWithImageNamed:@"guy"]];
            //dude.physicsBody = [SKPhysicsBody bodyWithTexture:dude.texture size:dude.size];
            dude.xScale = dude.xScale * -1;
            dudeD1.xScale = dudeD1.xScale * -1;
            dudeD2.xScale = dudeD2.xScale * -1;
            dudeD3.xScale = dudeD3.xScale * -1;
            dudeD4.xScale = dudeD4.xScale * -1;
        }
        [dude moveDudeWithDelta:data.acceleration.x];
        
        self.pevData = data.acceleration.x;
        
        if (self.moveCheck == 0) {
            self.moveCheck = 1;
        }
    }

    //NSLog(@"display pevData, %f", self.pevData);
}




-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //NSLog(@"contact!");
    //NSLog(@"first %d", firstBody.categoryBitMask);
    //NSLog(@"second %d", secondBody.categoryBitMask);
    if (secondBody.categoryBitMask == 4) {
        self.inAir = NO;
    }
    
    if (secondBody.categoryBitMask == 32) {
        self.onLevel6 = 1;
        self.inAir = NO;
    }
    
    if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 8) {
        self.inAir = NO;
    }
    
        
    if (secondBody.categoryBitMask == 2 && self.inAir == NO)
    {
        [self gameOverTop];
    }
    
    
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    /*
    if (!self.gameStarted) {
        [self gameStart];
    }
    else if(self.gameOvered == YES){
        [self restart];
    }
    else {
        [dude jump];
        self.inAir = YES;
    }
    */

   
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    [self processUserMotionForUpdate:currentTime];
}


-(void)scoresAndLabels
{
    
    HWGameData *data = [HWGameData data];
    [data load];
    
    HWLabels *pointsLabel = [HWLabels labelWithFont:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.position = CGPointMake(-self.scene.frame.size.width/2 + 100, self.scene.frame.size.height/2 - 50);
    [self addChild:pointsLabel];
    
    HWLabels *highPointsLabel = [HWLabels labelWithFont:GAME_FONT];
    highPointsLabel.name = @"highPointsLabel";
    highPointsLabel.position = CGPointMake(self.scene.frame.size.width/2 - 50, self.scene.frame.size.height/2 - 50);
    [highPointsLabel setPoints:data.highscore];
    [self addChild:highPointsLabel];
    
    /*SKLabelNode *bestPointsLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestPointsLabel.text = @"Best Points";
    bestPointsLabel.fontSize = 15.0;
    bestPointsLabel.position = CGPointMake(-60, 0);
    bestPointsLabel.fontColor = [UIColor grayColor];
    [highPointsLabel addChild:bestPointsLabel];
    
    SKLabelNode *currentPointsLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    currentPointsLabel.text = @"Score";
    currentPointsLabel.fontSize = 15.0;
    currentPointsLabel.position = CGPointMake(-30, 0);
    currentPointsLabel.fontColor = [UIColor grayColor];
    [pointsLabel addChild:currentPointsLabel];
    */
    
    SKSpriteNode *bestLabel = [SKSpriteNode spriteNodeWithImageNamed:@"best"];
    bestLabel.size = CGSizeMake(60, 20);
    bestLabel.position = CGPointMake(highPointsLabel.position.x - 50, highPointsLabel.position.y + 10);
    bestLabel.zPosition = 10;
    [self addChild:bestLabel];
    
    SKSpriteNode *currentLabel = [SKSpriteNode spriteNodeWithImageNamed:@"score"];
    currentLabel.size = CGSizeMake(60, 20);
    currentLabel.position = CGPointMake(pointsLabel.position.x - 40, pointsLabel.position.y + 10);
    currentLabel.zPosition = 10;
    [self addChild:currentLabel];
    

    
}

-(void)updateHighScore{
    HWLabels *pointsLabel = (HWLabels *)[self childNodeWithName:@"pointsLabel"];
    HWLabels *highPointsLabel = (HWLabels *)[self childNodeWithName:@"highPointsLabel"];
    if (pointsLabel.number > highPointsLabel.number) {
        [highPointsLabel setPoints:pointsLabel.number];
        HWGameData *data = [HWGameData data];
        data.highscore = pointsLabel.number;
        [data save];
    }
}




-(void)updateBackground
{
    int randColor = arc4random() % 6;
    switch (randColor) {
        case 0:
            self.backR = self.backR + 0.01;
            if (self.backR > 1) {
                self.backR = self.backR - 0.01;
            }
            break;
        case 1:
            self.backG = self.backG + 0.01;
            if (self.backG > 1) {
                self.backG = self.backG - 0.01;
            }            break;
        case 2:
            self.backB = self.backB + 0.01;
            if (self.backB > 1) {
                self.backB = self.backB - 0.01;
            }
            break;
        case 3:
            self.backR = self.backR - 0.01;
            if (self.backR < 0) {
                self.backR = self.backR + 0.01;
            }
            break;
        case 4:
            self.backG = self.backG - 0.01;
            if (self.backG < 0) {
                self.backG = self.backG + 0.01;
            }            break;
        case 5:
            self.backB = self.backB - 0.01;
            if (self.backB < 0) {
                self.backB = self.backB + 0.01;
            }
            break;

            
        default:
            break;
    }
    self.backgroundColor = [SKColor colorWithRed:self.backR green:self.backG blue:self.backB alpha:1.0];
}


-(void)getSkull
{
    if (self.springLevel < 6) {
        int totalDistance = (int)(self.scene.frame.size.height/10);
        SKAction *incrementUp = [SKAction moveByX:0 y:1 duration:0.04];
        SKAction *moveUp = [SKAction repeatAction:incrementUp count:totalDistance];
        [buttom runAction:moveUp];
        [buttomWall runAction:moveUp];
        [buttomWall2 runAction:moveUp];
        [springUp runAction:moveUp];
        [weight1 runAction:moveUp];
        [weight2 runAction:moveUp];
        [field runAction:moveUp];
        [self animate:springUp];
        self.springLevel = self.springLevel + 1;

    }
}

-(void)getShield
{

    if (self.springLevel > 0) {
        //everything here is actually moving down lol
        int totalDistance = (int)(self.scene.frame.size.height/10);
        SKAction *incrementUp = [SKAction moveByX:0 y:-1 duration:0.04];
        SKAction *moveUp = [SKAction repeatAction:incrementUp count:totalDistance];
        [buttom runAction:moveUp];
        [buttomWall runAction:moveUp];
        [buttomWall2 runAction:moveUp];
        [springUp runAction:moveUp];
        [weight1 runAction:moveUp];
        [weight2 runAction:moveUp];
        [field runAction:moveUp];
        [self animate:weight1];
        [self animate:weight2];
        self.springLevel = self.springLevel - 1;
    }
}

-(void)getDoubleField
{
    field.position = CGPointMake(0, field.position.y - self.scene.frame.size.height);
    SKAction *appear = [SKAction fadeAlphaTo:1 duration:0.5];
    self.fieldOn = YES;
    [field runAction:appear];
    NSTimer* fieldtimer;
    NSTimer* blinktimer;
    fieldtimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fieldGone) userInfo:nil repeats:NO];
    blinktimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(fieldBlink) userInfo:nil repeats:NO];
}

-(void)fieldGone
{
    field.position = CGPointMake(0, field.position.y + self.scene.frame.size.height);
}

-(void)fieldBlink
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:0.7 duration:0.4];
    SKAction *pulse = [SKAction sequence:@[appear, disappear]];
    [field runAction:[SKAction repeatAction:pulse count:3]];

    
}

-(void)animate:(SKNode *)node{
    
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:0.7 duration:0.3];
    SKAction *pulse = [SKAction sequence:@[appear, disappear]];
    [node runAction:[SKAction repeatAction:pulse count:3]];
}

-(void)animateForever:(SKNode *)node
{
    
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1];
    SKAction *appear = [SKAction fadeAlphaTo:0.7 duration:1];
    SKAction *pulse = [SKAction sequence:@[appear, disappear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}





@end
