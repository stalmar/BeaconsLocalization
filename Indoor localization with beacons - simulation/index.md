---
title       : Indoor localization with beacons - simulation
subtitle    : 
author      : stalmar
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Read-And-Delete

1. Edit YAML front matter
2. Write using R Markdown
3. Use an empty line followed by three dashes to separate slides!

--- .class #id 

## What are beacons ?

Beacons are bluetooth low energy transmitters, which can be used for many applications. One of them is indoor navigation/ localization systems, where GPS cannot be used.

Beacons, as useful as they are, have also some shortcomings. Signal emmited by them is unstable and noisy and without any filtering the precision of localization is sometimes. 

--- .class #id 

## What aplication is doing ?

In predefined room of size 10x20 (meters) one can choose ones (receiver) position (black dot in user interface)and choose how many beacons are present.

According to choices, application reactively simulates strength of signal that would be received in choosen position and plots the signal strength with barplot.

It also uses simulated signal strength to recalulate distances from beacons and estimate the position using min-max method.

The estimation error is computed and displayed with estimated position (red viewfinder).

--- .class #id 

## Why estimation ?

The signal received from beacon is noisy. In application it is assumed that it followes path loss model, as in http://www.dei.unipd.it/~zanella/PAPER/CR_2008/RealWSN08-CR.pdf, namely:

$$\P_i = \P_\(T_x)+ K - 10 theta \log_10(d_i/d_0) + \Psi_i + \alpha_i(t)$$

where $\Psi_i$ and $\alpha_i(t)$ are random variables and $$P_(T_x)+ K$$ is constant, dependend on environment and signal strength calibrated at the beacon.

Becouse of randomness the computation of localization is biased. One can also use many algorithm to estimate this position - application uses min max, as explained in http://www.consensus.tudelft.nl/documents_papers/compnw.pdf.

--- .class #id 

## Have fun!

Change the position of receiver, change the position of beacon and see how necessary it is to filter the signal to estimate your position ! :)

