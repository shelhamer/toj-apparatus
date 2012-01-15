/**
 * Time Order Judgement (TOJ) Apparatus
 *
 * Present time light pulses through LEDs, identify button press responses,
 * accepting pulse commands and returning responses over serial.
 * Developed for Patrick Taylor in the NeuroCognition and Perception (NCaP) lab
 * UMass Amherst
 *
 * Evan Shelhamer. Fall '10.
 */

/* CONSTANTS */

// LEDs, left or right
#define LED_L 11
#define LED_R 10

// Buttons
#define BUTTON_R 9
#define BUTTON_L 12

// Duration of LED lighting, total # of pulses, sequence length
#define DUR 15
#define NUM_PULSE 30

// Pulse array indices
#define LED 0
#define DELAY 1

/* PULSE DEFINITIONS */

// Defined as 1st LED to light, and delay until 2nd
// N.B. Pulses defined by Patrick Taylor
long pulses[NUM_PULSE][2] = {
  {LED_L, 3}, //0
  {LED_L, 6}, //1
  {LED_L, 9}, //2
  {LED_L, 12}, //3
  {LED_L, 15}, //4
  {LED_L, 18}, //5
  {LED_L, 21}, //6
  {LED_L, 24}, //7
  {LED_L, 27}, //8
  {LED_L, 30}, //9
  {LED_L, 33}, //10
  {LED_L, 36}, //11
  {LED_L, 39}, //12
  {LED_L, 42}, //13
  {LED_L, 45}, //14
  {LED_R, 3}, //15
  {LED_R, 6}, //16
  {LED_R, 9}, //17
  {LED_R, 12}, //18
  {LED_R, 15}, //19
  {LED_R, 18}, //20
  {LED_R, 21}, //21
  {LED_R, 24}, //22
  {LED_R, 27}, //23
  {LED_R, 30}, //24
  {LED_R, 33}, //25
  {LED_R, 36}, //26
  {LED_R, 39}, //27
  {LED_R, 42}, //28
  {LED_R, 45} //29
};

void setup() {
  // Initialize LED pins to output & off state
  pinMode(LED_L, OUTPUT);
  pinMode(LED_R, OUTPUT);
  digitalWrite(LED_L, LOW);
  digitalWrite(LED_R, LOW);

  // Initialize button pins for input
  pinMode(BUTTON_L, INPUT);
  pinMode(BUTTON_R, INPUT);

  // Open serial communication
  Serial.begin(9600);
}

void loop() {
  int cur_pulse = -1; // pulse to perform (signalled over serial)

  // Wait for serial message (single byte indicating pulse index), check valid
  while (Serial.available() == 0);
  cur_pulse = (int) Serial.read();
  if (!(cur_pulse >= 0 && cur_pulse < NUM_PULSE))
    return;

  // LED blink order & timing
  int led = pulses[cur_pulse][LED];
  int other = (led == LED_L) ? LED_R : LED_L;
  int delay_time = pulses[cur_pulse][DELAY];

  // Pause before stimulus presentation
  delay(1000);

  // Record start time (in milliseconds), declare event/reaction timekeeping var
  unsigned long start_ms = millis();
  unsigned long now_ms;

  // Calculate event timings
  unsigned long led1off = start_ms + DUR;
  unsigned long led2on = start_ms + delay_time;
  unsigned long led2off = led2on + DUR;

  // perform light pulse & wait for subject response (button press)
  boolean button_l, button_r; button_l = button_r = false;
  while (!(button_l || button_r)) {
    // Abort if serial message received
    if (Serial.available() > 0)
      return;

     now_ms = millis(); // current time in milliseconds

    // Light 1st LED for allotted duration
    if (now_ms <= led1off)
      digitalWrite(led, HIGH);
    else
      digitalWrite(led, LOW);

    // Light 2nd LED during allotted time frame
    if (led2on <= now_ms && now_ms <= led2off)
      digitalWrite(other, HIGH);
    else
      digitalWrite(other, LOW);

    // Check button state
    button_l = digitalRead(BUTTON_L);
    button_r = digitalRead(BUTTON_R);
  }

  // Send results to host computer: button, reaction time
  if (cur_pulse < 10) { Serial.print('0'); }
  Serial.print(cur_pulse);
  Serial.print((button_l) ? 'L' : 'R');
  Serial.println(now_ms - start_ms);

  // Turn off LEDs to prepare next pulse
  digitalWrite(LED_L, LOW);
  digitalWrite(LED_R, LOW);
}
