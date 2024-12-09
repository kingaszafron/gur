PImage mapImage;  // Obrazek statku
ArrayList<Wave> waves = new ArrayList<Wave>();
ArrayList<Area> areas = new ArrayList<Area>();
String infoText = "";
int lastSecond = -1;
float dayNightCycle = 0;  // Zmienna do cyklu dnia i nocy
float cycleDuration = 20000;  // Czas trwania cyklu (20 sekund)
int lastCycleChangeTime = 0;  // Czas ostatniej zmiany cyklu
int nightCount = 0;  // Zliczanie ilości nocy
float sinking = 0;  // Zmienna do kontrolowania tonięcia statku
int sinkingSpeed = 1;  // Prędkość tonięcia statku
int shipYPos = 0;  // Pozycja Y statku
float alpha = 255;  // Zmienna do kontroli przezroczystości statku

void setup() {
  fullScreen();
  mapImage = loadImage("statek.png");

  areas.add(new Area((1861 / 1919.0) * width, (662 / 1079.0) * height, 20, "Kultowe miejsce Jacka i Rose"));
  areas.add(new Area((102 / 1919.0) * width, (810 / 1079.0) * height, (1778 / 1919.0) * width, (880 / 1079.0) * height, "Kajuty 3 klasy"));
  areas.add(new Area((487 / 1919.0) * width, (587 / 1079.0) * height, (753 / 1919.0) * width, (581 / 1079.0) * height, "Łódź ratunkowa - 1"));
  areas.add(new Area((1148 / 1919.0) * width, (593 / 1079.0) * height, (1415 / 1919.0) * width, (572 / 1079.0) * height, "Łódź ratunkowa - 2"));
  areas.add(new Area((1744 / 1919.0) * width, (818 / 1079.0) * height, (160), "Miejsce dla załogi"));
  areas.add(new Area((483 / 1919.0) * width, (635 / 1079.0) * height, (40), "Kawiarnia Paryska"));

  waves.add(new Wave(1.5, 30, 4, 100));  
  waves.add(new Wave(2.0, 50, 3, 300));  
  waves.add(new Wave(1.8, 40, 5, 2));  
  waves.add(new Wave(5, 20, 6, 200));  
}

void draw() {
  // Sprawdzamy, czy 20 sekund minęło od ostatniej zmiany cyklu dnia/nocy
  if (millis() - lastCycleChangeTime > cycleDuration) {
    lastCycleChangeTime = millis();  // Resetujemy czas
    dayNightCycle = (dayNightCycle == 0) ? 1 : 0;  // Zmieniamy cykl dnia/nocy
    
    if (dayNightCycle == 1) {  // Jeśli zmieniliśmy na noc
      nightCount++;  // Zliczamy noc
      if (nightCount >= 5) {  // Po 5 nocach zaczynamy tonąć
        sinking = 0.2;  // Zaczynamy tonięcie statku
      }
    }
  }

  // Cykl dnia/nocy: Zmieniamy tło co 20 sekund
  if (dayNightCycle == 0) {
    background(135, 206, 250);  // Dzień: Jasne niebo
  } else {
    background(0, 0, 139);  // Noc: Granatowe niebo
  }

  // Rysowanie fal
  for (Wave wave : waves) {
    wave.update();  // Zaktualizowanie parametrów fal
    wave.draw();  // Rysowanie fal
  }

  // Rysowanie mapy statku
  if (sinking > 0) {
    shipYPos += sinking * sinkingSpeed;  // Jeśli statek tonie, przesuwamy go w dół
    alpha = max(0, alpha - 0.5);  // Zmniejszamy przezroczystość statku (max, żeby nie było ujemnych wartości)
  }

  // Ustawiamy przezroczystość statku
  tint(255, alpha);  // Ustawiamy przezroczystość na wartość alpha
  image(mapImage, 0, shipYPos, width, height);  // Rysowanie mapy (statku) w nowej pozycji
  noTint();  // Resetujemy ustawienie przezroczystości

  // Sprawdzanie obszaru pod kursorem
  for (Area area : areas) {
    if (area.isInside(mouseX, mouseY)) {
      infoText = area.label;  // Wyświetlanie etykiety na dole ekranu
    }
  }

  // Wyświetlanie tekstu informacyjnego na dole ekranu
  textSize(20);
  fill(255);
  text(infoText, width / 2 - textWidth(infoText) / 2, height - 30);

  // Dodanie zegara do wyświetlania godziny na ekranie
  String timeText = nf(hour(), 2) + ":" + nf(minute(), 2);
  textSize(40);
  fill(255);
  text(timeText, width - 120, 50);  // Wyświetlenie godziny w prawym górnym rogu
}

// Funkcja do obsługi naciśnięcia klawiszy
void keyPressed() {
  // Sprawdzamy, czy naciśnięto klawisz 'T' lub 't'
  if (key == 'T' || key == 't') {
    if (nightCount >= 5 && sinking == 0) {  // Tylko jeśli statek jeszcze nie tonie
      sinking = 0.2;  // Rozpoczynamy tonięcie statku
    }
  }
}

// Klasa do rysowania fal
class Wave {
  float waveSpeed;
  float waveAmplitude;
  float waveFrequency;
  float waveY;
  
  Wave(float speed, float amplitude, float frequency, float yOffset) {
    this.waveSpeed = speed;
    this.waveAmplitude = amplitude;
    this.waveFrequency = frequency;
    this.waveY = yOffset;
  }

  // Funkcja rysująca falę
  void draw() {
    stroke(255);
    noFill();
    beginShape();
    for (int x = 0; x < width; x++) {
      float y = waveAmplitude * sin(TWO_PI * waveFrequency * (x + waveY) / width) + height - 50;
      vertex(x, y);
    }
    endShape();
  }
  
  // Funkcja aktualizująca parametry fali
  void update() {
    // Prędkość fali zależna od pozycji kursora
    waveSpeed = map(mouseX, 0, width, 0.5, 5);  // Im bliżej prawej strony, tym szybsza fala
    waveY += waveSpeed;  // Przemieszczanie fali
    if (waveY > width) {
      waveY = 0;
    }

    // Zmienna amplituda i częstotliwość w zależności od czasu
    int currentMinute = minute();
    waveAmplitude = 30 + sin(TWO_PI * currentMinute / 60) * 50;  // Amplituda zależna od minuty
    waveFrequency = 4 + sin(TWO_PI * currentMinute / 60) * 2;    // Częstotliwość zależna od minuty
  }
}

// Klasa Area
class Area {
  float x1, y1, x2, y2;
  String label;
  float radius;

  Area(float x1, float y1, float x2, float y2, String label) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.label = label;
    this.radius = 0;
  }

  Area(float x, float y, float radius, String label) {
    this.x1 = x - radius;
    this.y1 = y - radius;
    this.x2 = x + radius;
    this.y2 = y + radius;
    this.label = label;
    this.radius = radius;
  }

  boolean isInside(float mouseX, float mouseY) {
    if (radius > 0) {
      return dist(mouseX, mouseY, (x1 + x2) / 2, (y1 + y2) / 2) < radius;
    }
    return mouseX >= x1 && mouseX <= x2 && mouseY >= y1 && mouseY <= y2;
  }
}
