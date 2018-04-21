shader_type spatial;
render_mode cull_disabled, unshaded, blend_add;

uniform sampler2D doftex;
uniform float focal_plane : hint_range(0, 10);
uniform float aperture : hint_range(0, 1);

void vertex()
{
	// this enables particle billboard mode
	mat4 mat_world = mat4(normalize(CAMERA_MATRIX[0])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[1])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[2])*length(WORLD_MATRIX[2]),WORLD_MATRIX[3]);
	mat_world = mat_world * mat4( vec4(cos(INSTANCE_CUSTOM.x),-sin(INSTANCE_CUSTOM.x),0.0,0.0), vec4(sin(INSTANCE_CUSTOM.x),cos(INSTANCE_CUSTOM.x),0.0,0.0),vec4(0.0,0.0,1.0,0.0),vec4(0.0,0.0,0.0,1.0));
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat_world;
}

void fragment()
{
	float x = min(1, length(UV - vec2(0.5, 0.5))*2.0);
	
	if (x >= 1.0 - 1e-9)
		discard;
	
	float y = abs(VERTEX.z + focal_plane) * aperture;
	
	//vec3 tint = vec3(0.4,0.12,0.1);
	vec3 tint = vec3(0.1,0.5,0.8);
	
	ALBEDO = texture(doftex, vec2(x,y)).rgb * tint * 0.2 * COLOR.rgb;
	
}