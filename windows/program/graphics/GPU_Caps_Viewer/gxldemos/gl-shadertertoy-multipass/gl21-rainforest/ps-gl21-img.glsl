
// Original code: https://www.shadertoy.com/view/4ttSWf

uniform vec3      iResolution;     
uniform float     iGlobalTime;     
uniform sampler2D iChannel0; 

// Created by inigo quilez - iq/2016
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


// Normals are analytical (true derivatives) for the terrain and for the clouds, that 
// includes the noise, the fbm and the smoothsteps involved chain derivatives correctly.
//
// Lighting and art composed for this shot/camera
//
// The trees are really cheap (ellipsoids with noise), but they kind of do the job in
// distance and low image resolutions.
//
// I used some cheap reprojection technique to smooth out the render, although it creates
// halows and blurs the image way too much (I don't the time now to do the tricks used in 
// TAA). Enable the STATIC_CAMERA define to see a sharper image.
//
// Lastly, it runs very slow. Sorry for that!


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = fragCoord/iResolution.xy;
    
    vec3 col = texture2D( iChannel0, p ).xyz;
    
    col *= 0.5 + 0.5*pow( 16.0*p.x*p.y*(1.0-p.x)*(1.0-p.y), 0.05 );
         
    fragColor = vec4( col, 1.0 );
}



void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0);mainImage( color, gl_FragCoord.xy );gl_FragColor = color;}  
