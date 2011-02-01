/* ===========================================================================
 
 Copyright (c) 2010-2011 Edward Patel
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 =========================================================================== */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>

//
// Delegate methods for you to implement your effect with
//
@protocol EPGLTransitionViewDelegate<NSObject>
// This is done when the GL context is active, setup matrices
- (void)setupTransition;

// 'textureFromView' is already active (bind)
// If no second texture was prepared 'textureToView' will not be valid
// return NO to end transition
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView; 

@optional
- (void)transitionEnded;
@end

@interface EPGLTransitionView : UIView
{    
@private
    id<EPGLTransitionViewDelegate> delegate;
    
    BOOL        animating;
    BOOL        displayLinkSupported;
    NSInteger   transitionFrameInterval;
    id          displayLink;
    NSTimer     *animationTimer;
    
    EAGLContext *context;
    
    GLint       backingWidth;
    GLint       backingHeight;
    
    GLuint      defaultFramebuffer;
    GLuint      colorRenderbuffer;
    GLuint      depthRenderbuffer;
    
    GLuint      textureFromView;
    GLuint      textureToView;
    
    CGSize      size;
    int         maxTextureSize;
    
    GLfloat     clearColor[4];
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger transitionFrameInterval;

- (id) initWithView:(UIView*)view 
           delegate:(id<EPGLTransitionViewDelegate>)delegate;
- (void) prepareTextureTo:(UIView*)view;
- (void) startTransition;
- (void) setClearColorRed:(GLfloat)red 
                    green:(GLfloat)green
                     blue:(GLfloat)blue
                    alpha:(GLfloat)alpha;
@end
