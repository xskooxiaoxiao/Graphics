// ECS610U -- Miles Hansard 2020

precision mediump float;

// light data
uniform struct {
    vec4 position, ambient, diffuse, specular;  
} light;

// material data
uniform struct {
    vec4 ambient, diffuse, specular;
    float shininess;
} material;

// clipping plane depths
uniform float near, far;

// normal, source and taget -- interpolated across all triangles
varying vec3 m, s, t;

//C2
float scene_depth(float frag_z)
{
    float ndc_z = 2.0*frag_z - 1.0;
    return (2.0*near*far) / (far + near - ndc_z*(far-near));
}

//C4
vec3 hsv_to_rgb(vec3 c) 
{
    vec4 k = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
    return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void main()
{   
    //C3
    // if(gl_FragCoord.z < 0.5) {
    //     // don't render close fragments
    //     discard;
    // }

    // renormalize interpolated normal
    vec3 n = normalize(m);

    // reflection vector
    vec3 r = -normalize(reflect(s,n));

    // phong shading components

    vec4 ambient = material.ambient * 
                   light.ambient;

    vec4 diffuse = material.diffuse * 
                   max(dot(s,n),0.0) * 
                   light.diffuse;

    //C3
    vec4 specular = material.specular *
                    pow(abs(dot(r,t)), material.shininess) *
                    light.specular;
    
    //C2
    float z = scene_depth(gl_FragCoord.z);
    float Depth = (far - z) / (far - near);

    //C4
    float PI = 3.1416;
    float Hue = (atan(n.y, n.x) + PI) / (2.0 * PI);
    float Saturation = 1.0 - n.z;
    float Value = 1.0;
    float modified_Saturation = pow(Saturation, 0.5);
    vec3 Hsv = vec3(Hue, modified_Saturation, Value);

    gl_FragColor = vec4(hsv_to_rgb(Hsv), 1.0);
    //gl_FragColor = vec4((ambient + diffuse + specular).rgb, 1.0);
    //gl_FragColor = vec4((ambient + diffuse + blinnSpecular).rgb, 1.0);
    //gl_FragColor = vec4(vec3(Depth), 1.0); C2

}

