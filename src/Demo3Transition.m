/* ===========================================================================
 
 Copyright (c) 2010 Edward Patel
 
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

#import "Demo3Transition.h"

@implementation Demo3Transition

- (void)setupTransition
{
    // Setup matrices
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationPortrait:
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            glRotatef(180, 0, 0, 1);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            glRotatef( 90, 0, 0, 1);
            break;
        case UIInterfaceOrientationLandscapeRight:
            glRotatef(-90, 0, 0, 1);
            break;
    }
    glFrustumf(-0.1, 0.1, -0.15, 0.15, 0.4, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();    
    glEnable(GL_CULL_FACE);
    f = 0;

    CGImageRef woodImage;
    size_t width;
    size_t height;
    
    woodImage = [UIImage imageNamed:@"table.jpg"].CGImage;

    width = CGImageGetWidth(woodImage);
    height = CGImageGetHeight(woodImage);
    
    if (woodImage) {
        GLubyte *woodImageData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
        CGContextRef imageContext = CGBitmapContextCreate(woodImageData, 
                                                          width, 
                                                          height, 
                                                          8, 
                                                          width * 4, 
                                                          CGImageGetColorSpace(woodImage), 
                                                          kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), woodImage);
        CGContextRelease(imageContext);
        
        glGenTextures(1, &woodTexture);
        glBindTexture(GL_TEXTURE_2D, woodTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, woodImageData);
        free(woodImageData);        
    }
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
    GLfloat vertices[] = {
        -1, -1.5,
         1, -1.5,
        -1,  1.5,
         1,  1.5,
    };
    
    GLfloat texcoords[] = {
        0, 1,
        1, 1,
        0, 0,
        1, 0,
    };
    
    GLfloat verticesSide[] = {
        1, -1.5,  -0.5,
		1,  1.5,  -0.5,
        1, -1.5,   0,
		1,  1.5,   0,
    };

    GLfloat texcoordsSide[] = {
        0.0, 0.0,
        0.0, 1.0,
        0.167, 0.0,
        0.167, 1.0,
    };
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glColor4f(1, 1, 1, 1);
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);

    float v = -(-cos(f)+1.0)/2.0; // For a little ease-in-ease-out
    
    glPushMatrix();
    glTranslatef(0, 0, -4.25-sin(-v*M_PI));
	glRotatef(v*180, 0, 1, 0);
    glTranslatef(0, 0, 0.25);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); // Draw front

    glBindTexture(GL_TEXTURE_2D, woodTexture);

	glVertexPointer(3, GL_FLOAT, 0, verticesSide);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoordsSide);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); // Draw side

    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);

	glBindTexture(GL_TEXTURE_2D, textureToView);
    glTranslatef(0, 0, -0.5);
	glRotatef(180, 0, 1, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); // Draw back
    glPopMatrix();

    f += M_PI/80.0;
    
    return f < M_PI;
}

- (void)transitionEnded
{
    glDeleteTextures(1, &woodTexture);
}

@end
