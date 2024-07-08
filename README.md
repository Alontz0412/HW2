Neurophotonics HW2
Alon Tzroya 209010651
1. Calculate for each recording (make a table)
a.	Temporal Noise – Column 2
b.	Global Spatial Noise (after averaging in time) - Column 3
c.	Local Spatial Noise with window size of 7 (after averaging in time) - Column 4
d.	Local Spatial Noise with window size of 7 per frame – then average over all frames. - Column 5
e.	Total Noise [totalNoise = √TemporalNoise2 + LocalSpatialNoise2] - Column 6
f.	Temporal Noise Contribution = temporalNoise2 /Mean – Column 7
g.	Theoretical Noise =  - Column 8
 
Figure 1. My code segment for the calculation
 
Figure 2. Table calculation
Answers to question (The index is in respect to the homework assignment):
d. The Total noise is relatively close to the Local Spatial noise per frame.
5. The Temporal Noise Contribution is relatively close to the Theoretical Noise only when the camera is open with an exposure time larger than 0.021ms as shown in Figure 2 first row.
2. Which noise is recorded when the exposure time is 21µs (given this is the minimum exposure time for that camera) and the camera is closed with a cover?
It’s the Quantum efficiency.
3. Which noises are recorded when the exposure time is >>21µs and the camera is closed with a cover?
It’s the Dark current which is measured without illumination (camera closed with a cover) and it’s dependent on the exposure time. The record with cover and higher exposure time is characterized by a higher total noise value compared to the minimum exposure time, as seen in Figure 2.
5. Which noise dominates in the recording when the camera is not closed, and the exposure time is >>21µs ? 
The dominant noise in these conditions is the temporal noise, or in other words the readout noise. As seen in Figure 3 the image received is not uniform some pixels registered higher intensities while other regions record fewer photons. Hence, the noise in different regions is different and this explains the difference between the noises. 
 
Figure 3. The image of the record with the open camera average over time
However, when observing the image of the speckle pattern in all of the other records where the camera is closed, we can see that the image is uniform. Furthermore, the global spatial noise and local spatial noise for those uniform images is similar, supporting my conclusion.
 
Figure 4. The image of the record average over time for each of the recording with the corresponding recording name
