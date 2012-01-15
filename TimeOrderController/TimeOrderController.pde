/**
 * Time Order Judgement (TOJ) Controller
 *
 * Trigger light pulse stimuli in apparatus, collect and record button responses
 * Developed for Patrick Taylor in the NeuroCognition and Perception (NCaP) lab
 * UMass Amherst
 *
 * Evan Shelhamer. Fall '10.
 */

import java.util.Scanner;
import java.util.LinkedList;
import java.io.FileWriter;
import java.io.IOException;

import processing.serial.*;

// Serial connection & port ID
Serial port;
final int PORT_NUM = 0; // ATTENTION: needs to be configured, see note below

/* Initialization */
void setup() {
  // Pulse sequence to execute, subject responses to record
  LinkedList seq;
  LinkedList resp;

  // List all the available serial ports on startup
  // Inspect list to look for apparatus connection...
  // ...and set PORT_NUM above to its order (counting from 0 for the 1st)
  println(Serial.list());

  // Open serial communication channel at 9600 baud speed
  port = new Serial(this, Serial.list()[PORT_NUM], 9600);

  // Disable graphics
  noLoop();

  // Keep running until user cancels or quits
  while(true) {
    /* SELECT INPUT SEQUENCE */
    try {
      seq = loadSequence(selectInput());
    }
    catch (FileNotFoundException e) {
      System.out.println("FILE NOT FOUND - PLEASE MAKE SURE THE SELECTED FILE EXISTS AND IS ACCESSIBLE");
      continue;
    }

    /* PRESENT SEQUENCE TO SUBJECT */
    resp = presentSequence(seq);

    /* RECORD RESULTS */
    boolean saved = false;
    while (!saved) { // keep trying until save successful to avoid data loss
      try {
        saved = saveResponses(selectOutput(), resp);
      }
      catch (IOException e) {
        System.out.println("COULD NOT SAVE FILE");
        System.exit(-1);
      }
    }
  }

  // HACK (unreachable code) System.out.println("Exiting...");
}

/* Load pulse sequences for transmission to apparatus */
LinkedList loadSequence(String filepath) throws FileNotFoundException {
  if (filepath == null)
    System.exit(0); // quit if no file is selected

  // Create scanner and configure for reading CSV
  Scanner sc = new Scanner(new File(filepath));
  sc.useDelimiter(",");

  // Create linked list and populate with pulse indices from file
  LinkedList fileSeq = new LinkedList();

  while(sc.hasNext()) {
    fileSeq.addFirst(sc.nextInt());
  }
  sc.close();

  System.out.println("Loaded " + filepath + "...");

  return fileSeq;
}

/* Present sequence by sending it to apparatus, one pulse at a time */
LinkedList presentSequence(LinkedList seq) {
  // for accumulating responses
  LinkedList resps = new LinkedList();

  // Iterate over each pulse in the sequence, sending each pulse
  // to the apparatus and waiting for the response recorded
  int cur_pulse = 1;
  int pulse_len = seq.size();
  while (seq.size() != 0) {
    Integer pulse_index = (Integer) seq.removeFirst();

    // Send pulse index (maps to a pulse coded onto apparatus)
    port.write(pulse_index);
    System.out.println("Sent " + cur_pulse + " of " + pulse_len + " pulses");

    // Keep trying to read response until complete (terminated by newline)
    String respStr = "";
    while (true) {
      if (port.available() > 0) {
        respStr += port.readString();
        if (respStr.charAt(respStr.length()-1) == '\n')
          break;
      }

      delay(10);
    }

    // Read entire response and store in response array
   resps.addFirst(respStr.trim());

   cur_pulse++;
  }

  return resps;
}

/* Save responses to text file (CSV) */
boolean saveResponses(String filepath, LinkedList resps) throws IOException {
  // Retry if no output file specified
  if (filepath == null)
    return false;

  // Open output file and write CSV header
  FileWriter out = new FileWriter(filepath);
  out.append("Pulse,Side,ReactionTime\n");

  // Iterate over each response and save to file
  while (resps.size() != 0) {
    // Pull off from list and split
    // into side (left/right) and reaction time (milliseconds)
    String respString = (String) resps.removeFirst();
    String pulse = respString.substring(0,2);
    String side = respString.substring(2,3);
    String time = respString.substring(3);


    // Output side & reaction time, comma-separated
    out.append(pulse + "," + side + "," + time + "\n");
  }

  // Flush & close output to finish saving
  out.flush();
  out.close();

  System.out.println("Saved results to " + filepath);

  return true;
}
