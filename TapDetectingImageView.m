
/*
     File: TapDetectingImageView.m
 Abstract: UIImageView subclass that responds to taps and notifies its delegate.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "TapDetectingImageView.h"

#define DOUBLE_TAP_DELAY 0.35

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);

@interface TapDetectingImageView ()
- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;
@end

@implementation TapDetectingImageView
@synthesize delegate = _delegate;

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
        _isTouchingAircraftBody = NO;
        
        // making a path shape just like aircraft, 
        // use for detecting whether user is tapping in the aircraft body or not(the aircraft but in the view) [Yufei Lang]
        _pathRef_AircraftUp=CGPathCreateMutable();
        CGPathMoveToPoint(_pathRef_AircraftUp, NULL, 0, 29);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 58, 29);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 58, 0);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 87, 0);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 87, 29);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 145, 29);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 145, 58);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 87, 58);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 87, 87);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 116, 87);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 116, 116);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 29, 116);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 29, 87);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 58, 87);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 58, 58);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 0, 58);
        CGPathAddLineToPoint(_pathRef_AircraftUp, NULL, 0, 29);
        CGPathCloseSubpath(_pathRef_AircraftUp);
    
    }
    return self;
}

- (void)setAircraftWithDirection: (AircraftDirection) direction
{
    switch (direction) {
        case Up:
        {
            int iTemp[5][5] =  {0,0,9,0,0,
                                1,1,1,1,1,
                                0,0,1,0,0,
                                0,1,1,1,0,
                                0,0,0,0,0};
            memcpy(_int2D_aircraft, iTemp, sizeof(int)*25);
            _direction = Up;
        }
            break;
        case Down:
        {
            int iTemp[5][5] =  {0,1,1,1,0,
                                0,0,1,0,0,
                                1,1,1,1,1,
                                0,0,9,0,0,
                                0,0,0,0,0};
            memcpy(_int2D_aircraft, iTemp, sizeof(int)*25);
            self.transform = CGAffineTransformMakeRotation(M_PI);
            _direction = Down;
        }
            break;
        case Left:
        {
            int iTemp[5][5] =  {0,1,0,0,0,
                                0,1,0,1,0,
                                9,1,1,1,0,
                                0,1,0,1,0,
                                0,1,0,0,0};
            memcpy(_int2D_aircraft, iTemp, sizeof(int)*25);
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            _direction = Left;
        }
            break;
        case Right:
        {
            int iTemp[5][5] =  {0,0,1,0,0,
                                1,0,1,0,0,
                                1,1,1,9,0,
                                1,0,1,0,0,
                                0,0,1,0,0};
            memcpy(_int2D_aircraft, iTemp, sizeof(int)*25);
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            _direction = Right;
        }
            break;
        default:
            break;
    }
}

- (int)int2D_aircraft:(int)row :(int)col
{
    return _int2D_aircraft[row][col];
}

- (void)aircraftPlaced // release retained memory [Yufei Lang 4/10/2012]
{
    if (_pathRef_AircraftUp != nil)
        CGPathRelease(_pathRef_AircraftUp); 
}

- (BOOL)isTouch:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint touchedPoint = [touch locationInView:self];
    switch (_direction) {
        case Up:
        {
            if (CGPathContainsPoint(_pathRef_AircraftUp, NULL, touchedPoint, NO))
                return YES;
            else
                return NO;
        }
        case Down:
        {
//            CGAffineTransform transf = CGAffineTransformMakeRotation(M_PI);
            if (CGPathContainsPoint(_pathRef_AircraftUp, NULL, touchedPoint, NO))
                return YES;
            else
                return NO;
        }
            break;
        case Left:
        {
//            CGAffineTransform transf = CGAffineTransformMakeRotation(-M_PI_2);
            if (CGPathContainsPoint(_pathRef_AircraftUp, NULL, touchedPoint, NO))
                return YES;
            else
                return NO;
        }
            break;
        case Right:
        {
//            CGAffineTransform transf = CGAffineTransformMakeRotation(M_PI_2);
            if (CGPathContainsPoint(_pathRef_AircraftUp, NULL, touchedPoint, NO))
                return YES;
            else
                return NO;
        }
            break;
        default:
            return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isTouch:touches withEvent:event])
    {
        _isTouchingAircraftBody = YES;
        [_delegate delegateTouchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isTouchingAircraftBody)
        [_delegate delegateTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isTouchingAircraftBody)
    {
        [_delegate delegateTouchesEnded:touches withEvent:event];
        _isTouchingAircraftBody = NO;
    }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}

#pragma mark Private

- (void)handleSingleTap {
    if ([_delegate respondsToSelector:@selector(tapDetectingImageView:gotSingleTapAtPoint:)])
        [_delegate tapDetectingImageView:self gotSingleTapAtPoint:tapLocation];
}

- (void)handleDoubleTap {
    if ([_delegate respondsToSelector:@selector(tapDetectingImageView:gotDoubleTapAtPoint:)])
        [_delegate tapDetectingImageView:self gotDoubleTapAtPoint:tapLocation];
}
    
- (void)handleTwoFingerTap {
    if ([_delegate respondsToSelector:@selector(tapDetectingImageView:gotTwoFingerTapAtPoint:)])
        [_delegate tapDetectingImageView:self gotTwoFingerTapAtPoint:tapLocation];
}
    
@end

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}
                    
