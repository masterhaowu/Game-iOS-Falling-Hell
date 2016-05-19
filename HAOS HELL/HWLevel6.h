//
//  level6.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/25/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HWLevel6 : SKSpriteNode
@property float barSpeed;
@property float deltaX;
@property float prevX;
@property BOOL isPositive;
@property BOOL onMe;

+(id)level6:(float)barSpeed;

@end
