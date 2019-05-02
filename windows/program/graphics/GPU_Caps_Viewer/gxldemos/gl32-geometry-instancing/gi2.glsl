[Vertex_Shader]
#version 330
#extension GL_ARB_draw_instanced: enable

in vec4 gxl3d_Position;
in vec4 gxl3d_Normal;
in vec4 gxl3d_TexCoord0;

in vec4 gxl3d_Instance_Position;
in vec4 gxl3d_Instance_Rotation;

uniform mat4 gxl3d_ProjectionMatrix;
uniform mat4 gxl3d_ViewMatrix;
uniform vec4 light_position;
uniform float time;

out vec4 Vertex_Normal;
out vec4 Vertex_UV;
out vec4 Vertex_LightDir;
out vec4 Vertex_EyeVec;


#define PI_OVER_180 0.01745329251994329576923690768489
/*
vec3 rotateVectorByQuaternion(vec3 v, vec4 q)
{
	vec3 dest = vec3( 0.0 );
	
	float x = v.x, y = v.y, z = v.z;
	float qx = q.x, qy = q.y, qz = q.z, qw = q.w;
	
	// calculate quaternion * vector
	
	float ix = qw * x + qy * z - qz * y,
	iy = qw * y + qz * x - qx * z,
	iz = qw * z + qx * y - qy * x,
	iw = -qx * x - qy * y - qz * z;
	
	// calculate result * inverse quaternion
	
	dest.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
	dest.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
	dest.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;
	
	return dest;
}

vec4 axisAngleToQuaternion(vec3 axis, float angle) 
{
	vec4 dest = vec4( 0.0 );
	
	float halfAngle = angle / 2.0,
	s = sin( halfAngle );
	
	dest.x = axis.x * s;
	dest.y = axis.y * s;
	dest.z = axis.z * s;
	dest.w = cos( halfAngle );
	
	return dest;
}
*/

mat4 makeInstanceTransform(vec4 pos, vec4 rot)
{
  float pitch=rot.x+time, yaw=rot.y+time*3.0, roll=rot.z*time*5.0;
	float cosX = cos(pitch*PI_OVER_180);
	float sinX = sin(pitch*PI_OVER_180);
	float cosY = cos(yaw*PI_OVER_180);
	float sinY = sin(yaw*PI_OVER_180);
	float cosZ = cos(roll*PI_OVER_180);
	float sinZ = sin(roll*PI_OVER_180);
  
  mat4 result;
  
  result[0][0]  = cosY * cosZ + sinX * sinY * sinZ;
	result[0][1]  = -cosX * sinZ;
	result[0][2]  = sinX * cosY * sinZ - sinY * cosZ;
	result[0][3]  = 0.0;

	result[1][0]  = cosY * sinZ - sinX * sinY * cosZ;
	result[1][1]  = cosX * cosZ;
	result[1][2]  = -sinY * sinZ - sinX * cosY * cosZ;
	result[1][3]  = 0.0;

  result[2][0]  = cosX * sinY;
  result[2][1]  = sinX;
  result[2][2] = cosX * cosY;
  result[2][3] = 0.0;

  result[3][0] = pos.x;
  result[3][1] = pos.y;
  result[3][2] = pos.z;
  result[3][3] = 1.0;
  
  return result;
}
/*
mat4 makeTransform(vec4 pos)
{
  mat4 T;
  
  T[0][0]  = 1.0;
	T[0][1]  = 0.0;
	T[0][2]  = 0.0;
	T[0][3]  = 0.0;

	T[1][0]  = 0.0;
	T[1][1]  = 1.0;
	T[1][2]  = 0.0;
	T[1][3]  = 0.0;

  T[2][0]  = 0.0;
  T[2][1]  = 0.0;
  T[2][2] = 1.0;
  T[2][3] = 0.0;

  T[3][0] = pos.x;
  T[3][1] = pos.y;
  T[3][2] = pos.z;
  T[3][3] = 1.0;
  
  return T;
}
*/

void main()
{
  mat4 modelMatrix = makeInstanceTransform(gxl3d_Instance_Position, gxl3d_Instance_Rotation);
  mat4 modelViewMatrix = gxl3d_ViewMatrix * modelMatrix;
  
  vec4 modelSpacePos = modelMatrix * gxl3d_Position;
  vec4 viewSpacePos = gxl3d_ViewMatrix * modelSpacePos;  
  gl_Position = gxl3d_ProjectionMatrix * viewSpacePos;  
  
  Vertex_UV = gxl3d_TexCoord0;
  
  Vertex_Normal = modelViewMatrix * gxl3d_Normal;
  
  Vertex_LightDir = light_position - viewSpacePos;
  Vertex_EyeVec = -viewSpacePos;
}

[Pixel_Shader]
#version 330
precision highp float;
uniform sampler2D tex0;
in vec4 Vertex_Normal;
in vec4 Vertex_UV;
in vec4 Vertex_LightDir;
in vec4 Vertex_EyeVec;
out vec4 Out_Color;


vec4 light_diffuse = vec4(0.9, 0.9, 0.9, 1.0);
vec4 material_diffuse = vec4(0.7, 0.7, 0.7, 1.0);
vec4 light_specular = vec4(0.9, 0.9, 0.9, 1.0);
vec4 material_specular = vec4(0.6, 0.6, 0.6, 1.0);
float material_shininess = 16.0;

void main()
{
  vec2 uv = Vertex_UV.xy;
  uv.y *= -1.0;
  vec4 tex01_color = texture(tex0, uv).rgba;
  
  vec4 final_color = vec4(0.2, 0.15, 0.15, 1.0) * tex01_color; 
  vec4 N = normalize(Vertex_Normal);
  vec4 L = normalize(Vertex_LightDir);
  float lambertTerm = dot(N,L);
  if (lambertTerm > 0.0)
  {
    final_color += light_diffuse * material_diffuse * lambertTerm * tex01_color;	
    
    vec4 E = normalize(Vertex_EyeVec);
    vec4 R = reflect(-L, N);
    float specular = pow( max(dot(R, E), 0.0), material_shininess);
    final_color += light_specular * material_specular * specular;	
  }

  Out_Color.rgb = final_color.rgb;
  Out_Color.a = 1.0;
   
   
   
   
}
