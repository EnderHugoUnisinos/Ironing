shader_type spatial;
render_mode blend_add;

uniform vec4 outline_color : source_color = vec4(0.999, 0.999, 0.999, 1);
uniform float emission_strength : hint_range(0, 50) = 8;
uniform bool is_highlighted = false;

uniform float pulse_speed : hint_range(0, 5) = 3.0;

varying vec3 world_position;
uniform float min_height = -1;
uniform float max_height = 0.4;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX.xy, 0.0, 1.0)).xyz;
}

void fragment() {
	if (is_highlighted == true) {
		float height = world_position.y - NODE_POSITION_WORLD.y;
		float factor = clamp((height - min_height) / (max_height - min_height), 0.0, 1.0);

        float pulse = sqrt(pow(sin(TIME * pulse_speed), 2));

        float animated_emission = emission_strength * pulse;

        float alpha = pow(1.0 - dot(NORMAL, VIEW), 3);

		EMISSION = outline_color.rgb * animated_emission;
		ALBEDO = outline_color.rgb;
		ALPHA = pow(1.0 - dot(NORMAL, VIEW), 3) * mix(0.8, 0, factor);
	}
	else
	{
		discard;
	}
}
