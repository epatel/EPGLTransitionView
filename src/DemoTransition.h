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

#import "EPGLTransitionView.h"

//
// This is a demo transition that breaks the screen in 4x6 squares that
// falls down off the screen.
//

// Enable this macro to enable the usage of a transition to bring in the new view
// #define ENABLE_PHASE_IN

@interface DemoTransition : NSObject<EPGLTransitionViewDelegate> {
    // 4x6 part, 4 vertex 2 coords
    GLfloat vertices[4][6][4][2];
    GLfloat texcoords[4][6][4][2];
    float yOut[4][6];
    float dyOut[4][6];
#ifdef ENABLE_PHASE_IN
    float yIn[4][6];
#endif
}

@end
