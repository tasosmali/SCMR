# Wireless Power Transfer via SCMR for Embedded Systems
[![License](https://img.shields.io/badge/license-BSD-blue.svg?style=plastic)](LICENSE)

![image](SCMR.png)

This was a project for a graduate course in Embedded Systems at [UC Davis](http://www.ece.ucdavis.edu). We built a system for wireless power transfer via Strongly-Coupled Magnetic Resonance (SCMR). We also developed a [Matlab program](SCMR.m) to calculate the resonant frequency to within 10%. It's worth noting that it wasn't a standard class project, and was both proposed and set out upon by two students with very little background on the subject-matter. If you've never had an opportunity to view wireless power transfer via SCMR, I encourage you to repeat our experiment, as one word immediately comes to mind when viewed in person.

 The two SCMR coils in the photo consist of 7 turns of 17 AWG wire with a diameter of 3.25 inches. The transmitting coil is being driven directly by a function generator. The smaller coil powering the LED is coupled to the receiving coil via standard induction (the two coils are simply held together using 3 rigid non-conductive white wrappings). An amplifier can be built to provide enough gain to wirelessly power a low-energy microprocessor (or charge a battery, etc). See the [PDF](SCMR4EmbdSys.pdf) for additional info on the system (Design III). In addition to the materials mentioned, some electrical tape and aerosol adhesive are useful to maintain the coils' shape, as minute changes alter the capacitances and resulting resonant frequencies. Also note the lead capacitances of the driver alter the transmitting coil's resonant frequency - the receiving coil's design should be altered accordingly (offset with an equivalent capacitance).

## Abstract
We briefly review the methods behind mid-range wireless power transfer using Strongly Coupled Magnetic Resonance (SCMR) to power embedded systems applications. From these reviewed methods, we then develop a mathematical model for SCMR to calculate resonant frequencies and other electrical characteristics for a given coil in MATLAB. The results from the model are verified experimentally through the implementation of several design iterations. The MATLAB model is accurate to within 10% of the experimental values for Design III. We also discuss the optimal design for maximum wireless power transfer and the constraints associated. Previous work shows wireless power transfer over 2 meters at about 40% efficiency with 60cm diameter resonating coils. We present a significantly scaled down design (Design III) with wireless power transfer via SCMR over 10cm using 8.25cm diameter coils, roughly 7.5 times smaller. The smaller design makes an excellent choice for powering small scale embedded systems applications.

## Acknowledgements
- Waqas Haque: Project partner, for transforming what we learned into a form that fit the course material.
- Michael Sitclaru: For independent thinking and ultimately leading us to the best solution.
- [Soheil Ghiasi](http://www.ece.ucdavis.edu/~soheil/): For allowing us the opportunity to try something different in his class.
- [Raj Amirtharajah](http://www.ece.ucdavis.edu/~ramirtha/promotion/amirtharajah_record.html): For encouragement.
