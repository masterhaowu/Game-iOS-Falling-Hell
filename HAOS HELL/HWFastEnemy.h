//
//  HWFastEnemy.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/26/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HWFastEnemy : SKSpriteNode
@property float SpeedOfEnemy;


+(id)generateEnemy:(float)enemySpeed;
@end
