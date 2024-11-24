/*
     2D Volumetric Display Simulator by Chris Bovee chrismofer@gmail.com
*/



import controlP5.*;
float radius2 = 50;
int redValue = 255;
int greenValue = 0;
int blueValue = 0;
ControlP5 cp5;

int fill_method = 0; //modes of voxel arrangement. 0 is close-to-constant pitch with aligned zeros.
int numPoints = 100; // Number of points to plot
float radius = 200;  // Radius of the circle
float LED_pitch = 2.5;
int display_width = 64;
int numVoxels;
float voxel_size = 2.5;
int basewidth = 10;
int current_LED;
float viewerscale = 2;
boolean rotator =false;
int leftR = 255;
int leftG = 100;
int leftB = 100;
int rightR = 100;
int rightG = 255;
int rightB = 255;
float rotationspeed = 0.0001;
float twistfactor; //100th of a rotation twist factor
float view_angle = 0.3;
float Z_sep=1; //extra coefficient to seperate the Z planes more or less if the height has differnt pitch
int display_height = 32;
float current_Z;
boolean Z_enabled = true;
boolean elliptical_voxels_enabled = true;
float elliptical_squeeze_factor = 1;
float esf_2 = 1;
float angle;
float x;
float y;
int i;
float diametral_random_twist = 0;
float diametral_random_twist_amount;
float circumferential_random_twist = 0;
float circumferential_random_twist_amount;

void setup() {
  surface.setResizable(true);
  cp5 = new ControlP5(this);
  cp5.addSlider("View Scale") .setPosition(width/2-150, 10) .setRange(0.2, 20) .setValue(viewerscale) .plugTo(this, "viewerscale") .setSize(300, 24);
  cp5.addSlider("Voxel size (mm)") .setPosition(width/2-150, 45) .setRange(0.5, 10) .setValue(voxel_size) .plugTo(this, "voxel_size") .setSize(200, 24);
 // cp5.addSlider("panel width in px") .setPosition(width/2-(512/2), 60) .setRange(1, 512) .setValue(display_width) .plugTo(this, "display_width") .setSize(512, 18);
  cp5.addSlider("matrix pitch (mm)") .setPosition(width/2-150, 80) .setRange(0.5, 100) .setValue(LED_pitch) .plugTo(this, "LED_pitch") .setSize(300, 24);
  cp5.addSlider("View altitude ") .setPosition(50, height-300-100) .setRange(0, 1) .setValue(view_angle*10) .plugTo(this, "view_angle") .setSize(24,300);
  cp5.addSlider("View azimuth") .setPosition(width/2-300, height-50) .setRange(0, 1) .setValue(twistfactor) .plugTo(this, "twistfactor") .setSize(600, 24);
   cp5.addSlider("Diametral_Random_Twist") .setPosition(150, height/2+150) .setRange(0, 1) .setValue(diametral_random_twist) .plugTo(this, "diametral_random_twist") .setSize(24, 100); //circumferential_random_twist
  cp5.addSlider("Circumferential_Random_Twist") .setPosition(150, height/2+300) .setRange(0, 1) .setValue(circumferential_random_twist) .plugTo(this, "circumferential_random_twist") .setSize(24, 100);
  
      cp5.addTextfield("panel width in px")
    .setPosition(20, 20)
    .setSize(60, 30)
    .setText(str(display_width))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      display_width = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
 ); 
 
 
       cp5.addTextfield("panel height in px")
    .setPosition(100, 20)
    .setSize(60, 30)
    .setText(str(display_height))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      display_height = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
 ); 
  
  
  RGBoptions();
  

  
  
  
  
  size(1000, 1000);
  background(40);
  translate(width/2, height/2);
  noFill();
  stroke(0);
  radius = display_width*LED_pitch; //set the max radius
  ellipse(0, 0, ((radius*2)+basewidth)*viewerscale, ((radius*2)+basewidth)*viewerscale); //draw an outline
  
  




  

}

void RGBoptions(){

    cp5.addTextfield("left RED")

    .setPosition(20, 50*2)
    .setSize(30, 30)
    .setText(str(leftR))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      leftR = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );


    cp5.addTextfield("left GREEN")
    .setPosition(20, 50*3)
    .setSize(30, 30)
    .setText(str(leftG))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      leftG = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );
  
      cp5.addTextfield("left BLUE")
    .setPosition(20, 50*4)
    .setSize(30, 30)
    .setText(str(leftB))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      leftB = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );
      cp5.addTextfield("right RED")
    .setPosition(90, 50*2)
    .setSize(30, 30)
    .setText(str(rightR))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      rightR = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );


    cp5.addTextfield("right GREEN")
    .setPosition(90, 50*3)
    .setSize(30, 30)
    .setText(str(rightG))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      rightG = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );


      cp5.addTextfield("right BLUE")
    .setPosition(90, 50*4)
    .setSize(30, 30)
    .setText(str(rightB))
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      String input = event.getController().getStringValue();
      rightB = int(parseFloat(input));
      //      cp5.get(Slider.class, "left display R").setValue(leftR);
    }
  }
  );



    cp5.getController("left RED").getCaptionLabel().setColor(color(255,100,30) );
        cp5.getController("right RED").getCaptionLabel().setColor(color(255,100,30) );
    cp5.getController("left GREEN").getCaptionLabel().setColor(color(0,255,100) );
        cp5.getController("right GREEN").getCaptionLabel().setColor(color(25,255,100) );
    cp5.getController("left BLUE").getCaptionLabel().setColor(color(20,100,255) );
        cp5.getController("right BLUE").getCaptionLabel().setColor(color(20,100,255) );






}


void plot_voxels_constant_pitch() {
  background(20);

  cp5 = new ControlP5(this);
  cp5.addButton("rotator")
    .setLabel("Rotate 90")
    .setPosition(10, height-10-30)
    .setSize(100, 30);
    
      cp5 = new ControlP5(this);
  cp5.addButton("Z_enabled_button")
    .setLabel("draw_Z_enabled")
    .setPosition(width-100-10, 10)
    .setSize(100, 30);
    
    
          cp5 = new ControlP5(this);
  cp5.addButton("elliptical_voxels")
    .setLabel("elliptical_voxels")
    .setPosition(width-100-10, 10+30+40)
    .setSize(100, 30);
    
    
    
    
    

  translate(width/2, height/2); //rotate the bitmap after drawing the button
  current_LED = display_width;
  
  

  

  //start of writing phase

  while (current_LED>0) {              //steps thru from the outer LED to the inner

    radius = current_LED*LED_pitch; //calculates the mm radius of the current ring

    float Circumference = radius*2*PI;
    numVoxels = int(Circumference/LED_pitch);  //calculates number of voxels in the current ring
    diametral_random_twist_amount = random(0,0.75);
    for (i = 0; i < numVoxels; i++) {      //goes thru every voxel in the ring first to last
      if (!rotator) {
        rotate(PI/2);
      }
                      circumferential_random_twist_amount = random(0,4)*circumferential_random_twist;
      draw_eye();
        current_Z = display_height;
         if(Z_enabled){current_Z = 1;}
        while (current_Z>0){
      polar_to_cartesian();
      
      
      
      noStroke();//(100);








                polar_to_cartesian();
  current_Z = current_Z-1;




      if (angle>=PI) {
        if(elliptical_voxels_enabled){ elliptical_squeeze_factor = esf_2*sin(angle-PI);}else{elliptical_squeeze_factor = 1;}
        fill(rightR*(sin(angle-PI)), rightG*(sin(angle-PI)), rightB*(sin(angle-PI))); //the blue side   
        ellipse((x*viewerscale)-(current_Z*(LED_pitch*Z_sep*viewerscale*(1-view_angle))), y*viewerscale, voxel_size*(viewerscale/2), voxel_size*(viewerscale/2)*(elliptical_squeeze_factor));
 
    }

      if (angle<PI) {
        if(elliptical_voxels_enabled){ elliptical_squeeze_factor = esf_2*sin(angle);}else{elliptical_squeeze_factor = 1;}
        fill(leftR*(sin(angle)), leftG*(sin(angle)), leftB*(sin(angle))); //the red side
        ellipse(x*viewerscale-(current_Z*(LED_pitch*Z_sep*viewerscale*(1-view_angle))), y*viewerscale, voxel_size*(viewerscale/2), voxel_size*(viewerscale/2)*(elliptical_squeeze_factor));
      }
      
        }

      if (!rotator) {
        rotate(-PI/2);
      }
    }
    current_LED = current_LED -1;
  }
  
  //end of drawing
  
  translate(-width/2, -height/2); //unrotate bitmap so you can draw button upright
  
  
  
  
  
  
  
  
}


  void polar_to_cartesian(){
  

      angle = (TWO_PI / numVoxels * i)+twistfactor+((circumferential_random_twist_amount+diametral_random_twist)*(diametral_random_twist_amount/current_LED));
      if (angle > 2*PI) {
        angle = angle-(2*PI);
      }
      x = (cos(angle) * radius*view_angle);
      y = (sin(angle) * radius);
      
}



void draw() {
  plot_voxels_constant_pitch();
}


void rotator() {
  rotator = !rotator;
}

void Z_enabled_button() {
Z_enabled = !Z_enabled;
}

void elliptical_voxels() {
  elliptical_voxels_enabled=!elliptical_voxels_enabled;
  //elliptical_squeeze_factor = 0;
}

void draw_eye() {
  fill(255, 255, 255);
  ellipse(((display_width*LED_pitch)+20)*viewerscale, 0, (20)*viewerscale, (20)*viewerscale); //draw an outline
  fill(0, 0, 0);
  ellipse(((display_width*LED_pitch)+13)*viewerscale, 0, (6)*viewerscale, (14)*viewerscale); //draw an outline
}
