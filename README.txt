Time Order Judgement (TOJ) Apparatus & Controller

A novel apparatus for presenting visual light pulses and recording time order
judgements with subject response time. ~1 millisecond precision in both light
presentation and response time measurement. Assembled with simple electronic
components on a breadboard connected to an Arduino Duemilanove, programmed in
Arduino, and interfaced to a computer via serial to a Processing app.

Time order judgements concern the evaluation and decision of the relative
ordering of a series of events. In this case, the apparatus has two diffuse
white LEDs that can be pulsed with precision of < 1 ms. Five types of pulse
pairs are possible:

*  >  * left on, right on, left off, right off
* --> * left on, left off, right on, right off
*  <  * the first with direction reversed
* <-- * the second with direction reversed
*  =  * both on on simultaneously

The delay between the onset of one pulse after the other is determined by
pulse pair definitions which are triggered by the apparatus controller running
on a computer.

The apparatus is necessary because the careful presentation of stimuli in time
is complicated by computer monitor refresh rates and time resolution is
inadequate for the short delays tested in time order judgement experiments.

Within a certain time threshold, an observer will see a sequence of two
pulses as one single, simultaneous pulse. This is similar to the echo threshold
and precedence effect in psychoacoustics: if the same sound signal arrives at
an observer at different times within a certain window, only the direction of
the first arrival is perceived. The curious can read more here:

http://murphylibrary.uwlax.edu/digital/journals/JASA/JASA1999/pdfs/vol_106/iss_4/1633_1.pdf

The apparatus and controller were designed, assembled, and programmed by Evan
Shelhamer. The idea for the apparatus and the specific experimental stimuli
light pulse patterns are due to Patrick Taylor, PhD student in the neuroscience
and behavior and cognitive divisions of UMass Amherst Psychology.

TimeOrderApparatus: arduino project for running the device itself. Presents
visual flashes through LEDs, accepts push button responses, and communicates
over serial.

TimeOrderController: processing.org project for running experiments with the
apparatus. Reads stimulus sequence files, commands the apparatus, and
records responses and reaction times collected from apparatus to CSV.

To make your own:

- Check the bill of materials.
- Consult the schematic and breadboard images for wiring.
- Refer to photos for an idea of its construction.
- Install the Arduino toolkit to load the software to the device.
- Install the Processing.org toolkit to run the experiment controller.
