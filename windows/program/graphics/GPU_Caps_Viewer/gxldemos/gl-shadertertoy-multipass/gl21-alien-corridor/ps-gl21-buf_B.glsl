
// Original code: https://www.shadertoy.com/view/4slyRs

#version 120

uniform vec3      iResolution;     
uniform float     iGlobalTime;     
uniform vec4      iMouse;          
uniform sampler2D iChannel0; 
uniform int       iFrame;     


//Blur Pass1
vec2 sampleDist = vec2(2.0,2.0);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{   
    vec2 uv = fragCoord.xy/iResolution.xy;
    
    vec4 tex = vec4(0.0);
    vec2 dist = sampleDist/iResolution.xy;
    
    for(int x = -2; x <= 2; x++)
    {
    	for(int y = -2; y <= 2; y++)
        {
			tex += texture2D(iChannel0, uv + vec2(x,y)*dist);
        }
    }
        
    tex /= 25.0;
    
	fragColor = tex;
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0);mainImage( color, gl_FragCoord.xy );gl_FragColor = color;}  
