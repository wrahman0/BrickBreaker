//
//  MyScene.m
//  BrickBreaker
//
//  Created by Wasiur Rahman on 2014-03-26.
//  Copyright (c) 2014 Wasiur Rahman. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;
@property (nonatomic) int bricks;

@end

@implementation MyScene


//BitMasking and flipping the bits. << is called a BitShift, effectively moving the bit to the left
static const uint32_t ballCategory   = 0x1;      // 00000000000000000000000000000001
static const uint32_t brickCategory  = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t paddleCategory = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t edgeCategory   = 0x1 << 3; // 00000000000000000000000000001000

- (void)didBeginContact:(SKPhysicsContact *)contact{

    if (contact.bodyA.categoryBitMask == brickCategory) {
        
        [contact.bodyA.node removeFromParent];
        self.bricks--;
        NSLog(@"Bricks Left: %d", self.bricks);
        
    }else if (contact.bodyB.categoryBitMask == brickCategory){
        
        [contact.bodyB.node removeFromParent];
        
    }
    
    
}

- (void)addBall:(CGSize)size {
    // create a new sprite node from an image
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    // create a CGPoint for position
    CGPoint myPoint = CGPointMake(size.width/2,size.height/10 * 3);
    ball.position = myPoint;
    
    // add a physics body
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 0;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory;

    //NOTE: The code below overrides the default collision of all objects to only brick and edge
    //ball.physicsBody.collisionBitMask = brickCategory | edgeCategory;
    
    
    // add the sprite node to the scene
    [self addChild:ball];
    
    // create the vector
    CGVector myVector = CGVectorMake(5, 5);
    // apply the vector
    [ball.physicsBody applyImpulse:myVector];
}

-(void) addBricks:(CGSize) size {

    for (int j = 0; j < 4; j++) {
        for (int i = 0; i < 4; i++) {

            self.bricks++;
            
            SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
            
            // add a static physics body
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.dynamic =  NO;
            brick.physicsBody.categoryBitMask = brickCategory;
            
            int xPos = size.width/5 * (i+1);
            int yPos = size.height - 50 - 35*j;
            brick.position = CGPointMake(xPos, yPos);
            
            [self addChild:brick];
            
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        
        // stop the paddle from going too far
        if (newPosition.x < self.paddle.size.width / 2) {
            newPosition.x = self.paddle.size.width / 2;
            
        }
        if (newPosition.x > self.size.width - (self.paddle.size.width/2)) {
            newPosition.x = self.size.width - (self.paddle.size.width/2);
            
        }
        
        self.paddle.position = newPosition;
    }
}

-(void) addPlayer:(CGSize)size  {
    
    // create paddle sprite
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    // position it
    self.paddle.position = CGPointMake(size.width/2,100);
    // add a physics body
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    // make it static
    self.paddle.physicsBody.dynamic = NO;
    
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    // add to scene
    [self addChild:self.paddle];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        // add a physics body to the scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody.categoryBitMask = edgeCategory;
        
        [self addBall:size];
        [self addPlayer:size];
        [self addBricks:size];
        
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end