precision mediump float;

// A4: ADD CODE HERE
varying lowp vec4 colour_var;

void main()
{
    // A2 & A4: MODIFY BELOW

    //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    gl_FragColor = colour_var;
}

