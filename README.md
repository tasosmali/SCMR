# Wireless Power Transfer via SCMR for Embedded Systems
[![License](https://img.shields.io/badge/license-BSD-blue.svg?style=plastic)](LICENSE)

![image](SCMR.png)

## Preface
This was a project built in Fall 2014 for a graduate course in Embedded Systems at [UC Davis](http://www.ece.ucdavis.edu). We designed a system for wireless power transfer via Strongly-Coupled Magnetic Resonance (SCMR). We also developed a [Matlab program](SCMR.m) to calculate the resonant frequency to within 5% for the design in the photo. It's worth noting that this was a different type of project, and was proposed and set out on by two students with minimal background on the subject-matter. If you've never had an opportunity to view wireless power transfer via SCMR, I encourage you to repeat our experiment, as one word comes to mind when observed in person.

## [Abstract](SCMR4EmbdSys.pdf)
We briefly review the methods behind mid-range wireless power transfer using Strongly Coupled Magnetic Resonance (SCMR) to power embedded systems applications. From these reviewed methods, we then develop a mathematical model for SCMR to calculate resonant frequencies and other electrical characteristics for a given coil in MATLAB. The results from the model are verified experimentally through the implementation of several design iterations. The MATLAB model is accurate to within 5% of the experimental values for Design III. We also discuss the optimal design for maximum wireless power transfer and the constraints associated. Previous work shows wireless power transfer over 2 meters at about 40% efficiency with 60cm diameter resonating coils. We present a significantly scaled down design with wireless power transfer via SCMR over 10cm using 8.25cm diameter coils, roughly 7.5 times smaller. The smaller design makes an excellent choice for powering small scale embedded systems applications.

### [2017 Experimental Refresh](Refresh.md)

### Acknowledgements
* [Waqas Haque](https://www.linkedin.com/in/waqas-haque-651b2231/): Project partner, for transforming what we learned into a form that fit the course material.
* [Soheil Ghiasi](http://www.ece.ucdavis.edu/~soheil/): For allowing us the opportunity to try something different in his class.
* Michael Sitclaru: For independent thinking and ultimately leading us to the best solution.
* [Leo Liu + DART group](https://faculty.engineering.ucdavis.edu/liu/): For allowing us to experiment with a high-frequency function generator.
* [Raj Amirtharajah](http://www.ece.ucdavis.edu/~ramirtha/promotion/amirtharajah_record.html): For encouragement.

#### License & Citation
This repository is released under the [BSD 2-Clause license](LICENSE).  
Please [cite](Citation.md) this work if it helps your project / research.
