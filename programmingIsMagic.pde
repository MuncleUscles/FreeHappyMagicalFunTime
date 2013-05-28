int windowW = 600;
int windowH = 600;
static boolean opengl = true; //Set False if opengl problems

boolean showHelp = true;
boolean fullscreen = true;

float circleRes = 100;
int numOfLines = 30;
float lineLength = 100;
float lineRotationCoef = 4;
float lineSpacing = 10;
float strokeCoef = 25;
boolean mirroring = true;
float bGroundClearAlpha = 500;

float maxDiam;

float circleHueCoef = 2;
float lineHueCoef = 2;
float lineAlphaCoef = 2;
float lineSatCoef = 2;
float lineValueCoef = 2;
float minHue = 100;
float maxHue = 500;
float minSat = 500;
float maxSat = 1000;
float minV = 500;
float maxV = 1000;
float minAlpha = 500;
float maxAlpha = 1000;

float strokeSatCoef = 50;
float strokeSatMaxChange = 100;
float strokeValCoef = 50;
float strokeValMaxChange = 100;
float strokeAlphaCoef = 50;
float strokeAlphaMaxChange = 100;

float lineCosCoef = 1000;
float lineSinCoef = 1000;

float angleChange = PI/2000;
float hueChange = 15;

float angle = 0;
float h = 1000;

boolean smoo=false;

  
boolean sketchFullScreen() {
  return fullscreen;
}

void setup()
{
     
  if(fullscreen)
  {
    windowW = displayWidth;
    windowH = displayHeight;
  }
  if(opengl)
    size(windowW, windowH, OPENGL);
  else
  {
    size(windowW, windowH, JAVA2D);
    noSmooth();
  }
    
  
  
  if (frame != null) {
    frame.setSize(windowW, windowH);
    frame.setLocation((displayWidth - windowW)/2, (displayHeight - windowH)/2);
  }
 
  colorMode(HSB, 1000);
  background(1000);
  randomize();
}

void randomize()
{
  maxDiam = sqrt(windowW*windowW + windowH*windowH); 
  
  numOfLines = round(pow(random(2, 4), 2))*2;
  lineLength = random(10, 100);
  lineSpacing = random(5, 30); 
  
  if(random(1) > 0.5) mirroring = !mirroring;
  bGroundClearAlpha = 1/random(0.01, numOfLines);
  
  angleChange = random(PI/5000, PI/2500);
  if(random(1) > 0.5) angleChange = -angleChange;  
  hueChange = random(5, 15);
  if(random(1) > 0.5) hueChange = -hueChange;  
  
  minHue = random(0, 1000);
  maxHue = (minHue + random(200, 300))%1000;
  minSat = random(100, 500);
  maxSat = random(500, 1000);
  minV = random(1000, 500);
  maxV = random(500, 1000);
  minAlpha = random(50, 300);
  maxAlpha = random(300, 500);
  
  strokeSatCoef = random(0, 50);
  strokeSatMaxChange = 200;
  strokeValCoef = random(-50, 0);
  strokeValMaxChange = 200;
  strokeAlphaCoef = random(0, 50);
  strokeAlphaMaxChange = 200;
  
  lineHueCoef = 1/random(0.05, 3);  
  lineAlphaCoef = 1/random(0.001, 2);  
  lineSatCoef = 1/random(0.001, 2); 
  lineValueCoef = 1/random(0.001, 2); 
  lineRotationCoef = pow(2, round(random(2, 6)));  
  strokeCoef = 1/random(0.01, 0.2);
  
  lineSinCoef = random(500, 2000);
  if(random(1) > 0.5) lineSinCoef = -lineSinCoef;  
  lineCosCoef = random(500, 2000);
  if(random(1) > 0.5) lineCosCoef = -lineCosCoef; 
  
  angle = 0;
  h = maxDiam * circleHueCoef;
  
  
}

void draw()
{
  
  
  fill(0, 0, 1000, bGroundClearAlpha);
  noStroke();
  rect(0, 0, windowW, windowH);
  
  pushMatrix();
  
  translate(windowW/2, windowH/2);
  
  
  for(int j=0; j < numOfLines; j++)
  {
    
    pushMatrix();
    for(float i=0; i > -maxDiam/2; i -= lineSpacing )
    {
      //strokeWeight(1 + abs(i)/strokeCoef);
      //stroke((h - i*lineHueCoef + 500) % 1000, 1000, 1000); 
      //noStroke();
      
      float fh = ((h - i/1400*maxDiam*lineHueCoef) % maxHue + minHue)%1000;
      float fs = (h - i/700*maxDiam*lineSatCoef) % maxSat + minSat;
      float fv = (h - i/700*maxDiam*lineValueCoef) % maxV + minV;
      float fa = (h - i/1400*maxDiam*lineAlphaCoef) % maxAlpha + minAlpha;
      
      fill(fh, fs, fv, fa); 
      
      strokeWeight(1);
      
      float sh = fh;
      float ss = fs + i*strokeSatCoef % strokeSatMaxChange;
      float sv = fv + i*strokeValCoef % strokeValMaxChange;
      float sa = fa + i*strokeAlphaCoef % strokeAlphaMaxChange;
      stroke(sh, ss, sv, sa); 
      
      pushMatrix();
      
      translate(0, i - lineLength/2);
      rotate(angle*lineRotationCoef);
      
      float c = cos(angle + i/lineCosCoef);
      float s = sin(angle + i/lineSinCoef);
      float x1 = abs(i)/strokeCoef * c - lineLength/2 * s;
      
      beginShape();
      vertex(x1, lineLength/2);
      vertex(x1*2,  lineLength/2);
      vertex(-x1,  -lineLength/2);
      vertex(-x1*2,  -lineLength/2);
      endShape();
      
      popMatrix();
      
      rotate(angle);
    }
    popMatrix();
    
    if(mirroring)
      angle = -angle;
    
    rotate(PI / (numOfLines / 2));
  }  
  
  h += hueChange;
  angle += angleChange;
  if(h < 0) h = 1000-h;
  
  popMatrix();
  
  
  if(showHelp)
  {
    textSize(12);
    fill(0, 0, 1000);
    text("Press R to randomize", 5, 15);
    text("Press Space or click to flip direction", 5, 30);  
    text("Press S to save a screenshot", 5, 45);
    text("Press H to hide this", 5, 60);  
  }
}

void keyPressed()
{
  if(key == 's' || key == 'S')
  {
    /*
    smoo = !smoo;
    if(smoo) smooth();
    else noSmooth();
    */
    saveFrame("magic "+month()+"."+day()+" "+hour()+"."+minute()+"."+second()+".jpeg");
  }  
  else if(key == 'r' || key == 'R')
  {
    randomize();
  }  
  else if(key == 'h' || key == 'H')
  {
    showHelp = !showHelp;
  }  
  else if(key == ' ')
  {
    angleChange = -angleChange;
  } 
  else if(key == '-'  && !opengl)
  {
    fullscreen = false;
    if(windowW > displayWidth/10)
    {
      windowW -= displayWidth/10;
      windowH -= displayHeight/10;
    }
    
    setup();
  } 
  else if(key == '+'  && !opengl)
  {
    fullscreen = false;
    windowW += displayWidth/10;
    windowH += displayHeight/10;
    
    if(windowW >= displayWidth) fullscreen = true;
    
    setup();
  } 
  else if(key == 'f' || key == 'F')
  {
    fullscreen = !fullscreen;
    setup();
  }  
}

void mouseClicked()
{
  //randomize();
  angleChange = -angleChange;  
  //hueChange = -hueChange;
} 
