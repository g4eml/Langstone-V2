
#include <stdio.h>
#include <string.h>
#include "Graphics.h"
#include "Touch.h"

void processTouch();
void detectHw();
void initGUI(void);
int buttonTouched(int bx,int by);

int mousePresent;
int touchPresent;
int hyperPixelPresent;
char mousePath[20];
char touchPath[20];

#define limeButtonX 0
#define limeButtonY 250
#define exitButtonX 266
#define exitButtonY 250
#define plutoButtonX 533
#define plutoButtonY 250



#define buttonHeight 200
#define buttonWidth 266

int exitValue;

int main(int argc, char* argv[])
{
  detectHw();
  initScreen();
  if(touchPresent) initTouch(touchPath);
  initGUI();
  exitValue=-1;
  
  while(1)
  {
                                                                                                                    
   if(touchPresent)
     {
       if(getTouch()==1)
        {
         processTouch();
        }
     }
     
     if(exitValue != -1)
     {
         exit(exitValue);
     }
     
   }
}





void detectHw()
{
  FILE * fp;
  char * ln=NULL;
  size_t len=0;
  ssize_t rd;
  int p;
  char handler[2][10];
  char * found;
  p=0;
  mousePresent=0;
  touchPresent=0;
  fp=fopen("/proc/bus/input/devices","r");
   while ((rd=getline(&ln,&len,fp)!=-1))
    {
      if(ln[0]=='N')        //name of device
      {
        p=0;
        if((strstr(ln,"FT5406")!=NULL) || (strstr(ln,"pi-ts")!=NULL))         //Found Raspberry Pi TouchScreen entry
          {
           p=1;
           hyperPixelPresent=0;
          }
        if(strstr(ln,"Goodix")!=NULL)                                         //Found Hyperpixel TouchScreen entry
          {
          p=1;
          hyperPixelPresent=1;
          }                                                                  
      }
      
      if(ln[0]=='H')        //handlers
      {
         if(strstr(ln,"mouse")!=NULL)
         {
           found=strstr(ln,"event");
           strcpy(handler[p],found);
           handler[p][6]=0;
           if(p==0) 
            {
              sprintf(mousePath,"/dev/input/%s",handler[0]);
              mousePresent=1;
            }
           if(p==1) 
           {
             sprintf(touchPath,"/dev/input/%s",handler[1]);
             touchPresent=1;
           }
         }
      }   
    }
  fclose(fp);
  if(ln)  free(ln);
  
  if ((fp = fopen("/home/pi/hyperpixel4/install.sh", "r")))                      //test to see if Hyperpixel4 file is present. If so we dont use the GPIO pins. 
  {
    fclose(fp);
    hyperPixelPresent=1;
  }
  else
  {
    hyperPixelPresent=0;
  }
  
}



void initGUI()
{
  clearScreen();
  system("sudo cp /home/pi/Langstone/select.bgra /dev/fb0");  
}



void processTouch()
{ 

if(hyperPixelPresent==1)
{
float tempX=touchX;
float tempY=touchY;
tempX=tempX*0.6;                    //convert 0-800 to 0-480
tempY=800-(tempY*1.6666);           //convert 480-0   to 0-800
touchX=tempY;                       //swap X and Y
touchY=tempX;
}

if(buttonTouched(limeButtonX,limeButtonY))    //Lime
    {
      exitValue=91;
      return;
    }
 
 if(buttonTouched(plutoButtonX,plutoButtonY))    //Pluto
    {
      exitValue=92;
      return;
    }
 
 if(buttonTouched(exitButtonX,exitButtonY))    //Exit
    {
      exitValue=0;
      return;
    }
                                                      
}


int buttonTouched(int bx,int by)
{
  return ((touchX > bx) & (touchX < bx+buttonWidth) & (touchY > by) & (touchY < by+buttonHeight));
}

