//
//  HWFastEnemy.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/26/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWFastEnemy.h"

@implementation HWFastEnemy


+(id)generateEnemy:(float)enemySpeed
{
    HWFastEnemy *fastEnemy = [HWFastEnemy spriteNodeWithImageNamed:@"devil30"];
    fastEnemy.name = @"fastEnemy";
    fastEnemy.SpeedOfEnemy = enemySpeed;
    return fastEnemy;
    
}


@end
