// Based on
// Conway's game of life

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D texture;

uniform int spark;

void main( void )
{
  vec3 BG   = vec3(0.,0.,0.); // make sure that the colors
  vec3 EH   = vec3(0.,0.,1.); //   are set correctly
  vec3 ET   = vec3(1.,0.,0.);
  vec3 WIRE = vec3(1.,1.,0.);
  
  vec2 position = ( gl_FragCoord.xy / resolution.xy );
  vec2 pixel = 1./resolution;
  
  
  if (spark == 1) // left mouse to electron
  {
    if (length(gl_FragCoord.xy-mouse) < 1.)
    {
      gl_FragColor = vec4(EH.rgb, 1.);
      return;
    }
  }
  else if (spark == 2) // right mouse --> wire
  {
    if (length(gl_FragCoord.xy-mouse) < 1.)
    {
      gl_FragColor = vec4(WIRE.rgb, 1.);
      return;
    }
  }
  
  vec4 me = texture2D(texture, position);
  
  if (me.rgb == EH)
  {
    gl_FragColor = vec4(ET.rgb, 1.);
  }
  else if (me.rgb == ET)
  {
    gl_FragColor = vec4(WIRE.rgb, 1.);
  }
  else if (me.rgb == WIRE)
  {
    float sum = 0.0;
    sum += texture2D(texture, position + pixel * vec2(-1., -1.)).b;
    sum += texture2D(texture, position + pixel * vec2(-1., 0.)).b;
    sum += texture2D(texture, position + pixel * vec2(-1., 1.)).b;
    sum += texture2D(texture, position + pixel * vec2(1., -1.)).b;
    sum += texture2D(texture, position + pixel * vec2(1., 0.)).b;
    sum += texture2D(texture, position + pixel * vec2(1., 1.)).b;
    sum += texture2D(texture, position + pixel * vec2(0., -1.)).b;
    sum += texture2D(texture, position + pixel * vec2(0., 1.)).b;
    
    // electron head color value contains blue
    // become active if surrounded by 1 or 2 electrons
    if ((sum >= 0.9) && (sum <= 2.1))
    {
      gl_FragColor = vec4(EH.rgb, 1.);
    }
    else
    {
      gl_FragColor = vec4(WIRE.rgb, 1.);
    }
  }
  else
  {
    gl_FragColor = me;
  }
}