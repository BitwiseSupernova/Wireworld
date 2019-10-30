
//Wireworld
// Using the "Static wallpaper" version of the
// wireworld computer from:
//  https://www.quinapalus.com/wi-index.html
//
// Colors used in images (ranges 0-255):
// Electron start (head), blue, color(0,0,255)
// Electron end (tail), red, color(255,0,0)
// Wire, yellow, color(255,255,0)
// Background, black, color(0)

int SPACE=0, HEAD=color(0,0,255), TAIL=color(255,0,0), WIRE=color(255,255,0);

int w=512, h=512;

int addtype=0;
boolean storeimage = false;

int[] imgout = new int[w*h];
int[] whatitwas = new int[w*h];

PImage org = new PImage(w,h);

void setup()
{
  size(512,512,P2D);
  
  // Dimensions must match image since this example is
  //   using the sketch's pixels[] array
  
  org = loadImage("circuit.bmp");// image is 512x512
  org.loadPixels();
  
  w = org.width;
  h = org.height;
  
  System.arraycopy(org.pixels,0,imgout,0,imgout.length);
  System.arraycopy(imgout,0,whatitwas,0,imgout.length);
  
  frameRate(30);
}

void keyReleased() {
  if (keyCode == '1')
  {
    addtype = SPACE;
  }
  else if (keyCode == '2')
  {
    addtype = HEAD;
  }
  else if (keyCode == '3')
  {
    addtype = TAIL;
  }
  else if (keyCode == '4')
  {
    addtype = WIRE;
  }
  else if (keyCode == 'p')
  {
    storeimage = true;
  }
}

void draw()
{
  for (int x=1; x<w-1; x++)
  {
    for (int y=1; y<h-1; y++)
    {
      int i = y * w + x;
      
      if (whatitwas[i] == HEAD)
      {
        imgout[i] = TAIL;
      }
      else if (whatitwas[i] == TAIL)
      {
        imgout[i] = WIRE;
      }
      else if (whatitwas[i] == WIRE)
      {
        int electcount=0;
        
        if (whatitwas[y * w + (x + 1)] == HEAD) electcount++;
        if (whatitwas[(y + 1) * w + (x + 1)] == HEAD) electcount++;
        if (whatitwas[(y + 1) * w + x] == HEAD) electcount++;
        if (whatitwas[(y - 1) * w + (x + 1)] == HEAD) electcount++;
        if (whatitwas[(y - 1) * w + x] == HEAD) electcount++;
        if (whatitwas[(y - 1) * w + (x - 1)] == HEAD) electcount++;
        if (whatitwas[y * w + (x - 1)] == HEAD) electcount++;  
        if (whatitwas[(y + 1) * w + (x - 1)] == HEAD) electcount++;
               
        if ((electcount == 1) || (electcount == 2))
        {
          imgout[i] = HEAD;
        }
      }
    }
  }
  
  if (mousePressed && (mouseButton == LEFT))
  {
    int idx = mouseY * w + mouseX;
    imgout[idx] = addtype;
  }
  
  System.arraycopy(imgout,0,whatitwas,0,imgout.length);
  
  loadPixels();
  System.arraycopy(imgout,0,pixels,0,imgout.length);
  updatePixels();
}
