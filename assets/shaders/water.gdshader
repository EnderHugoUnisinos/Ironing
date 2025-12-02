shader_type spatial;
render_mode cull_disabled;
render_mode diffuse_burley, specular_schlick_ggx, blend_mix;


uniform sampler2D NOISE_PATTERN;
uniform vec4 color = vec4(1,1,1,1);

uniform vec4 edge_color : source_color = vec4(0.0, 0.5, 0.7, 1.0);
group_uniforms albedo;
uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 0.0);

uniform sampler2D screen_texture : hint_screen_texture, source_color, repeat_disable;
uniform sampler2D normal_map_texture : hint_normal;
uniform vec3 water_color : source_color = vec3(0.0625, 0.1992, 0.3594);
uniform float index_of_refraction = 1.0;
varying vec2 tex_position;

float SchlickFresnel(float u) {
	float m = 1.0 - u;
	float m2 = m * m;
	return m2 * m2 * m;
}


void fragment() {
	float VdotN = dot(VIEW, NORMAL);
	float fresnel = clamp(SchlickFresnel(VdotN), 0.0, 1.0);

	ROUGHNESS = 0.0;
	RIM = 0.2;
	SPECULAR = 1.0;


	vec3 normal_sample_1 = texture(NOISE_PATTERN, UV + vec2(TIME, -TIME)/20.0).xyz;
	vec3 normal_map = vec3(normal_sample_1.xy, 0.0);
	NORMAL_MAP = normal_map;

	float a = mix(0.200, 1.0, albedo.a);
	ALPHA = mix(fresnel * edge_color.a, 1.0, a);
	ALPHA += 0.1 * sqrt(ALPHA);

	vec2 distorted_uv = (SCREEN_UV - normal_map.xy) / length(VERTEX);
	ALBEDO = texture(screen_texture, distorted_uv).rgb + mix(fresnel * edge_color.rgb * edge_color.a, albedo.rgb, a);
	IRRADIANCE = vec4(vec3(1.0), 1.0);
}