//
//  EndScene.m
//  BrickBreaker
//
//  Created by Wasiur Rahman on 2014-03-28.
//  Copyright (c) 2014 Wasiur Rahman. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"
#import "WinScene.h"

@implementation EndScene

-(instancetype)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]){
        
        self.backgroundColor = [SKColor darkGrayColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.fontColor = [SKColor whiteColor];
        label.text = @"GAME OVER";
        label.fontSize = 45;
        label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:label];
        
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        tryAgain.fontColor = [SKColor whiteColor];
        tryAgain.text = @"Try Again";
        tryAgain.fontSize = 25;
        tryAgain.position = CGPointMake(self.frame.size.width/2, -50);
        
        
        SKAction *moveUp = [SKAction
                            moveToY:self.frame.size.height/2 - self.frame.size.height/10
                                    duration:2];
        
        [tryAgain runAction:moveUp];
        [self addChild:tryAgain];
        
        
    }
    
    return self ;
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    MyScene *begin = [MyScene sceneWithSize:self.size];
    [self.view presentScene:begin transition:[SKTransition doorsOpenHorizontalWithDuration:2]];
    
}

@end
