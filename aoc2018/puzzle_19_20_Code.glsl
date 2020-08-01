/*
Shadertoy Solution for Advent of Code, 2018, Day 10
This goes into the Image tab.

Lot's of trial and error in this puzzle. Values for the solution were found by tweeking values using iMouse.
*/

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //vec2 uv = (fragCoord/iResolution.xy * 2. - 1.) * (iMouse.y / iResolution.y) * 0.001 + vec2(0.0017,0.0013);
	vec2 uv = (fragCoord/iResolution.xy * vec2(2., -2) - vec2(1., -1)) * 0.4 * 0.001 + vec2(0.0017,0.0013);

    float c = 0.;
    //float time = 10158. + iMouse.x/iResolution.x * 2.;
    float time = 10158. + 0.5 * 2.;	// answer for part 2 is 10159
    for (int i = 0; i < data.length(); i += 4) {
        float posX = float(data[i]);
        float posY = float(data[i+1]);
        float velX = float(data[i+2]);
        float velY = float(data[i+3]);
        float x = (posX + velX * time) / 102400.;
        float y = (posY + velY * time) / 102400.;
        //if (max(abs(x - uv.x), abs(y - uv.y)) < 0.000015 * (iMouse.y / iResolution.y)) {
        if (max(abs(x - uv.x), abs(y - uv.y)) < 0.000015 * .35) {
            c = 1.;
            break;
        }
    }
    
    fragColor = vec4(c);
}
