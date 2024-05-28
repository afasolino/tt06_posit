<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The module (Fig. 1) is fed by two fixed-point numbers, namely af and bf, coverts them into the posit arithmetic [1] format (ap and bp) and sums them to produce a posit output (sp).

![fixed2posit-module drawio](https://github.com/afasolino/tt06_posit/assets/151364130/2e2fa7f1-4080-490b-bbb9-8ac1b462cae2)

It is made of two units: 
1) 16-bit 2's complement fixed-point 0.15 coded to 16-bit standard posit (16,1) converter, namely fixed to posit converter;
2) posit adder, that executes the addition of posit numbers according to the posit standard.


1.
The conversion is operated as described in [1], leveraging a leading zero counter [2] and some glue logic.


2.
The addition leverages the architecture presented in [3].

References

[1] J. Gustafson. "Posit arithmetic." Mathematica Notebook describing the posit number system, 2017.

[2] Milenković, Nebojša & Stankovic, Vladimir & Milić, Miljana. (2015). Modular Design Of Fast Leading Zeros Counting Circuit. Journal of Electrical Engineering. 66. 329-333. 10.2478/jee-2015-0054. 

[3] R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, doi: 10.1109/ISCAS45731.2020.9180771.

## How to test

Provide two fixed-point input data and they will be added in posit arithmetic.
