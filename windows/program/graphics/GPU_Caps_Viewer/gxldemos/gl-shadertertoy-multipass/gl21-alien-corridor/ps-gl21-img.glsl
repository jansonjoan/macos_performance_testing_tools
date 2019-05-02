
// Original code: https://www.shadertoy.com/view/4slyRs

#version 120

uniform vec3      iResolution;     
uniform float     iGlobalTime;     
uniform vec4      iMouse;          
uniform sampler2D iChannel0, iChannel1; 


//bloom & vignet effect

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{ 
    vec2 uv =  fragCoord.xy/iResolution.xy;
   
    vec4 tex = texture2D(iChannel1, uv);
    vec4 texBlurred = texture2D(iChannel0, uv);
    float vignet = length(uv - vec2(0.5))*1.5;
        
	fragColor = mix(tex, texBlurred*texBlurred, vignet) + texBlurred*texBlurred*0.5;
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0);mainImage( color, gl_FragCoord.xy );gl_FragColor = color;}  
