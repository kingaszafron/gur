PImage trasa;
PImage statek;
PImage gora;
float statekPos = 0;  
float statekWidth, statekHeight;
float scaleFactor = 0.5;  // minimalny wzrost statku (od tego rozmiaru statek zaczyna )
float maxScale = 1.0;     // maksymalny wzrost statku (na tym statek kończy)
float scaleSpeed = 0.002; // prędkość powiększania się statku

// trasa titanica, punkty przez, które przepływa
float[] trasaX = {1469,1360,1172,960,912};
float[] trasaY = {387,362,448,523,515};

void setup() {
  fullScreen();
  trasa = loadImage("trasa.jpg");
  gora = loadImage("gora.png");
  statek = loadImage("statek.png");
  statekWidth = statek.width / 5;
  statekHeight = statek.height / 5;
}

void draw() {
  // gdy statek osiąga ostatni punkt na trasie ekran zmienia się na czarny kolor
  int index = int(statekPos) % trasaX.length;
  if (index == trasaX.length - 1) {
   background (0);
  } else {
    background(0); 
    displayImage(trasa);
    goralodowa(gora);
    movestatek(statek);

    // Powiększanie się statku wraz z trasą przebytą
    if (scaleFactor < maxScale) {
      scaleFactor += scaleSpeed; 
    }
  }
}

//wyświetlanie się góry lodowej
void goralodowa (PImage trasa) {
  image(gora, 752, 440, width / 7, height / 4);
}

//wyświetlanie się na cały ekran mapy, na której widać trasę titanica
void displayImage(PImage trasa) {
  image(trasa, 0, 0, width, height);
}


// ruch statku przez mapę
void movestatek(PImage statek) {
  
  int index = int(statekPos) % trasaX.length;  
  int nextIndex = (index + 1) % trasaX.length; 
  
  // Interpolacja między dwoma punktami
  float x = lerp(trasaX[index], trasaX[nextIndex], statekPos - index);
  float y = lerp(trasaY[index], trasaY[nextIndex], statekPos - index);

  // rysowanie statku + powiekszanie się statku 
  image(statek, x, y, statekWidth * scaleFactor, statekHeight * scaleFactor);

  // pozycja statku
  statekPos += 0.02;  // szybkość ruchu 
  if (statekPos >= trasaX.length) {
    statekPos -= trasaX.length;
  }
}
