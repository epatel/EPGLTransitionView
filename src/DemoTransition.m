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

#import "DemoTransition.h"

@implementation DemoTransition

- (void)setupTransition
{
    srand(time(NULL));
    
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
    glOrthof(-1, 1, -1.5, 1.5, -10, 10); // Could also use glFrustum here for a 3D look
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // Setup vertex data 
    int i, j;
    const float kdx = 2.0/4.0;
    const float kdy = 3.0/6.0; // yes, they are same because parts are square, but here for completeness
    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            float vx = -1.0+kdx*i;
            float vy = -1.5+kdy*j;
            float tx = i/4.0;
            float ty = (5-j)/6.0;
            vertices[i][j][0][0] = vx;
            vertices[i][j][0][1] = vy;          
            vertices[i][j][1][0] = vx+kdx;
            vertices[i][j][1][1] = vy;
            vertices[i][j][2][0] = vx;
            vertices[i][j][2][1] = vy+kdy;
            vertices[i][j][3][0] = vx+kdx;
            vertices[i][j][3][1] = vy+kdy;
            texcoords[i][j][0][0] = tx;
            texcoords[i][j][0][1] = ty+1.0/6.0;         
            texcoords[i][j][1][0] = tx+1.0/4.0;
            texcoords[i][j][1][1] = ty+1.0/6.0;
            texcoords[i][j][2][0] = tx;
            texcoords[i][j][2][1] = ty;
            texcoords[i][j][3][0] = tx+1.0/4.0;
            texcoords[i][j][3][1] = ty;
            yOut[i][j] = 0;
            dyOut[i][j] = 0;
#ifdef ENABLE_PHASE_IN
            if (j)
                yIn[i][j] = yIn[i][j-1]+3.0/6.0+(rand()%200)/500.0;
            else
                yIn[i][j] = 3.0+3.0/6.0+(rand()%200)/500.0;
#endif
        }
    }
    
    // Activate the vertex data
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
    int i, j;
    
    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            glPushMatrix();
            glTranslatef(0, -yOut[i][j], 0);
            glDrawArrays(GL_TRIANGLE_STRIP, (i*6+j)*4, 4);
            glPopMatrix();
        }
    }
    BOOL allAreGone = YES;
    for (j=0; j<6; j++) {
        int moved = 0;
        for (i=0; i<4; i++) {
            if (dyOut[i][j] > 0.0) {
                yOut[i][j] += dyOut[i][j];
                dyOut[i][j] *= 1.1;
                moved++;
            }
#ifdef ENABLE_PHASE_IN
            if (yOut[i][j] < 0.5) 
                allAreGone = NO;
#else
            if (yOut[i][j] < 3.0) 
                allAreGone = NO;
#endif
        }
        if (moved<4) {
            if (rand()%100 > 50) {
                while (1) { // naïve loop to find a none moving square
                    i = rand()%4;
                    if (!(dyOut[i][j] > 0.0)) {
                        dyOut[i][j] = 0.02;
                        break; // got one, leave now
                    }
                }
            }
            break; // no more moving squares, leave outer loop
        }
    }
    
#ifdef ENABLE_PHASE_IN
    
    glBindTexture(GL_TEXTURE_2D, textureToView);
    
    if (allAreGone) {
        for (i=0; i<4; i++) {
            for (j=0; j<6; j++) {
                glPushMatrix();
                glTranslatef(0, yIn[i][j], 0);
                glDrawArrays(GL_TRIANGLE_STRIP, (i*6+j)*4, 4);
                glPopMatrix();
                yIn[i][j] -= 0.05;
                if (yIn[i][j] < 0.0) {
                    yIn[i][j] = 0.0;
                } else {
                    allAreGone = NO;
                }
            }
        }
    }
    
#endif
    
    return !allAreGone;
}

#if 0
- (void)transitionEnded
{
    NSLog(@"transitionEnded");
}
#endif

@end
