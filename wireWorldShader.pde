// GLSL version of Wireworld
// Using the "Static wallpaper" version of the
// wireworld computer from:
//  https://www.quinapalus.com/wi-index.html
//
// Colors used in images and by shader
// Ranges 0-255:
// Electron start (head), blue, color(0,0,255)
// Electron end (tail), red, color(255,0,0)
// Wire, yellow, color(255,255,0)
// Background, black, color(0)

boolean spark = false;

PShader wireworld;
PImage org;

int toggle = 0;

PGraphics[] buff = new PGraphics[2];

void setup() {
  size(800,600,P2D);
  
  // These circuits are _not_ my design
  org = loadImage("ww800x600.png"); // especially this one
  //org = loadImage("circuit.bmp");
  org.loadPixels();
  
  buff[0] = createGraphics(org.width, org.height, P2D);
  buff[1] = createGraphics(org.width, org.height, P2D);
  
  buff[1].beginDraw();
  buff[1].image(org, 0,0);
  buff[1].endDraw();
  
  wireworld = loadShader("wire.glsl");
  wireworld.set("resolution", float(org.width), float(org.height));
  
  fill(255);
  
  frameRate(300);
}

void draw()
{
  // Careful here, pixel dimensions are assumed to match...
  float x = float(mouseX);
  float y = float(height-mouseY); // GL y-axis is flipped
  wireworld.set("mouse", x, y);
  
  // press and hold mouse buttons to modify the simulation
  if (mousePressed)
  {
    if (LEFT == mouseButton)
    {
      wireworld.set("spark", 1);
    }
    else if (RIGHT == mouseButton)
    {
      wireworld.set("spark", 2);
    }
    spark = false;
  }
  else
  {
    wireworld.set("spark", 0);
  }
  
  buff[toggle].beginDraw();
  buff[toggle].shader(wireworld);
  buff[toggle].image(buff[toggle^1],0,0);
  buff[toggle].endDraw();
  
  image(buff[toggle], 0, 0, width, height);
  
  toggle ^= 1;
  
  text(frameCount, 20, height - 50);
}
