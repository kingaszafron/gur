PImage statek;
PImage gora;
float statekPos = 0;  
float statekWidth, statekHeight;

// trasa titanica, punkty przez, które przepływa
float[] trasaX = {1469, 495};
float[] trasaY = {515, 515};

void setup(){
  fullScreen();
  gora = loadImage("gora.png");
  statek = loadImage("statek.png");
  statekWidth = statek.width / 5;
  statekHeight = statek.height / 5;
}

void draw(){
  // gdy statek osiąga ostatni punkt na trasie ekran zmienia się na czarny kolor
  int index = int(statekPos) % trasaX.length;
  if (index == trasaX.length - 1) {
    background(0);
  } else {
    background(70, 130, 180);
    goralodowa(gora);
    movestatek(statek);
  }
}


// Funkcja wyświetlająca obrazek góry na ekranie
void goralodowa(PImage gora) {
  image(gora, 362, 400, width / 6, height / 3);
}

// Ruch statku przez ekran
void movestatek(PImage statek) {
  int index = int(statekPos) % trasaX.length;  
  int nextIndex = (index + 1) % trasaX.length; 
  
  // Interpolacja między dwoma punktami - ruch
  float x = lerp(trasaX[index], trasaX[nextIndex], statekPos - index);
  float y = lerp(trasaY[index], trasaY[nextIndex], statekPos - index);

  // rysowanie statku  
  image(statek, x, y, statekWidth, statekHeight);

  // pozycja statku
  statekPos += 0.002;  // szybkość ruchu 
  if (statekPos >= trasaX.length) {
    statekPos -= trasaX.length;
  }
}
