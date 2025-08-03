shader_type canvas_item;
render_mode unshaded;

uniform vec4 color : source_color;
uniform float strength : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 current = texture(TEXTURE, UV);
	vec4 mixed_color = mix(current, color, strength);

	COLOR.rgb = mixed_color.rgb;
}