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
    glFrustumf(-0.1, 0.1, -0.15, 0.15, 0.4, 100.0);
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

	glColor4f(1, 1, 1, 1);
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    float v = -(-cos(f)+1.0)/2.0; // For a little ease-in-ease-out
    
    glPushMatrix();
    glTranslatef(0, 0, -4.25-sin(-v*M_PI));
	glRotatef(v*180, 0, 1, 0);
    glTranslatef(0, 0, 0.25);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	glColor4f(0.2, 0.2, 0.2, 1);
	glDisable(GL_TEXTURE_2D);
	
	glVertexPointer(3, GL_FLOAT, 0, verticesSide);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	glColor4f(1, 1, 1, 1);
	glEnable(GL_TEXTURE_2D);

    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glBindTexture(GL_TEXTURE_2D, textureToView);
    glTranslatef(0, 0, -0.5);
	glRotatef(180, 0, 1, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();

    f += M_PI/80.0;
    
    return f < M_PI;
}

- (void)transitionEnded
{
}

@end
