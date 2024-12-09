void setup() {
  fullScreen();  // Ustawienie trybu pełnoekranowego
}

void draw() {
  background(0);  // Ustawienie tła na czarne
  
  // Wyświetlenie pozycji kursora w lewym górnym rogu ekranu
  fill(255);  // Ustawienie koloru tekstu na biały
  textSize(32);  // Ustawienie rozmiaru tekstu
  text("Pozycja kursora: (" + mouseX + ", " + mouseY + ")", 50, 50);
}
