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

#import "Demo2Transition.h"

@implementation Demo2Transition

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
    glFrustumf(-0.1*1.0/0.4, 0.1*1.0/0.4, 
               -0.15*1.0/0.4, 0.15*1.0/0.4, 
               1.0, 10.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();    
    glEnable(GL_CULL_FACE);
    f = 0;
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
    GLfloat vertices[] = {
        -1, -1.5,
         0, -1.5,
        -1,  1.5,
         0,  1.5,
         0, -1.5,
         1, -1.5,
         0,  1.5,
         1,  1.5,
    };
    
    GLfloat texcoords[] = {
        0.0, 1,
        0.5, 1,
        0.0, 0,
        0.5, 0,
        0.5, 1,
        1.0, 1,
        0.5, 0,
        1.0, 0,
    };
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    float v = -(-cos(f)+1.0)/2.0; // For a little ease-in-ease-out
    
    glPushMatrix();
    glTranslatef(0, 0, -4);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPushMatrix();
    glRotatef(v*180.0, 0, 1, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    glRotatef(180.0, 0, 1, 0);
    glBindTexture(GL_TEXTURE_2D, textureToView);
    glPolygonOffset(0, -1);
    glEnable(GL_POLYGON_OFFSET_FILL);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisable(GL_POLYGON_OFFSET_FILL);
    glPopMatrix();
    glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    glPopMatrix();

    f += M_PI/40.0;
    
    return f < M_PI;
}

- (void)transitionEnded
{
}

@end
