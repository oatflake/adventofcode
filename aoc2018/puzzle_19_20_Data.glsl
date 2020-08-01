/*
Shadertoy Solution for Advent of Code, 2018, Day 10
This goes into the Common tab.
*/

const int[] data = int[](-30302,  30614,  3, -3, 
-20164, -10027,  2,  1, 
-20135,  50933,  2, -5, 
 40801, -40503, -4,  4, 
-50633,  10291,  5, -1, 
 40811, -50658, -4,  5, 
 30674,  10292, -3, -1, 
-40445,  30609,  4, -3, 
-20155,  20447,  2, -2, 
-30283, -50665,  3,  5, 
 -9995, -20185,  1,  2, 
 -9978,  20451,  1, -2, 
 30671, -40507, -3,  4, 
-20139,  50930,  2, -5, 
-50596, -30341,  5,  3, 
-40445, -40499,  4,  4, 
-30318, -10030,  3,  1, 
-40458,  30615,  4, -3, 
 30671, -40500, -3,  4, 
 -9973, -20184,  1,  2, 
 20513,  20451, -2, -2, 
 30663, -10024, -3,  1, 
 10313,  50929, -1, -5, 
 50960,  20447, -5, -2, 
 51001,  30609, -5, -3, 
 30631, -20181, -3,  2, 
 50986, -50657, -5,  5, 
 20480,  20451, -2, -2, 
 40798,  30611, -4, -3, 
 50965,  40769, -5, -4, 
 10358,  40766, -1, -4, 
-20116,  50931,  2, -5, 
 -9960, -50659,  1,  5, 
-50625,  10289,  5, -1, 
 20506, -50662, -2,  5, 
 10332, -50662, -1,  5, 
 40806,  30612, -4, -3, 
 50941,  30613, -5, -3, 
-50589, -10026,  5,  1, 
-40469, -10029,  4,  1, 
 10305,  20455, -1, -2, 
-30283,  30614,  3, -3, 
 40822, -20180, -4,  2, 
 50989,  30614, -5, -3, 
 50983,  20451, -5, -2, 
 -9968,  50930,  1, -5, 
 -9973,  10288,  1, -1, 
 -9973, -40504,  1,  4, 
 50967,  20451, -5, -2, 
-30307,  20456,  3, -2, 
 10334,  10290, -1, -1, 
-50601,  50925,  5, -5, 
-30323,  50924,  3, -5, 
 30639,  50931, -3, -5, 
-50601,  40774,  5, -4, 
-30283, -20184,  3,  2, 
 50941, -20183, -5,  2, 
-30323, -40504,  3,  4, 
 10315,  40768, -1, -4, 
-20156, -20188,  2,  2, 
-40445,  20452,  4, -2, 
 50965, -20188, -5,  2, 
 -9973,  10290,  1, -1, 
 40790,  30607, -4, -3, 
-40456,  30611,  4, -3, 
 20509, -40507, -2,  4, 
-30311, -40503,  3,  4, 
 10306, -10021, -1,  1, 
 20504, -30345, -2,  3, 
-30315,  20448,  3, -2, 
 -9973, -40498,  1,  4, 
-20162, -30342,  2,  3, 
 20497, -20180, -2,  2, 
-30294, -30346,  3,  3, 
-20139,  20456,  2, -2, 
 50941, -20188, -5,  2, 
 30683,  10288, -3, -1, 
 -9969,  40769,  1, -4, 
-40456,  10288,  4, -1, 
 30668,  40773, -3, -4, 
-50633,  50931,  5, -5, 
 40806, -10028, -4,  1, 
-50596, -20181,  5,  2, 
-10002, -30341,  1,  3, 
-30323,  40774,  3, -4, 
-10013, -50666,  1,  5, 
 10358,  20448, -1, -2, 
 -9984, -20189,  1,  2, 
-20160, -20188,  2,  2, 
 20497, -10021, -2,  1, 
 10339, -10021, -1,  1, 
-40445, -30347,  4,  3, 
 50994,  50930, -5, -5, 
-40461,  20448,  4, -2, 
 -9953, -30340,  1,  3, 
 10341, -30339, -1,  3, 
-20115, -30339,  2,  3, 
-20143, -40502,  2,  4, 
-50589, -20184,  5,  2, 
 30658, -50662, -3,  5, 
-30331, -30341,  3,  3, 
 20472, -30342, -2,  3, 
 50951, -10024, -5,  1, 
 20472,  50930, -2, -5, 
-40438,  20451,  4, -2, 
 20524,  10292, -2, -1, 
 20517, -50666, -2,  5, 
-30291, -10029,  3,  1, 
 10315,  50927, -1, -5, 
 50986, -30348, -5,  3, 
 40782,  20455, -4, -2, 
-30275,  30614,  3, -3, 
 -9964, -50662,  1,  5, 
 50993, -20185, -5,  2, 
 40801, -40503, -4,  4, 
 -9968, -30342,  1,  3, 
 51001, -20187, -5,  2, 
-30286, -50662,  3,  5, 
 40842,  30607, -4, -3, 
-40461,  40772,  4, -4, 
 20492, -20185, -2,  2, 
-40445,  50928,  4, -5, 
 10305, -50657, -1,  5, 
-50608,  10292,  5, -1, 
 10305, -20182, -1,  2, 
-20151, -10028,  2,  1, 
 30659,  10291, -3, -1, 
-50589,  30612,  5, -3, 
-30291, -50662,  3,  5, 
 40816, -10021, -4,  1, 
 -9997, -40501,  1,  4, 
 30644, -30345, -3,  3, 
 40834,  20451, -4, -2, 
-30302,  30612,  3, -3, 
 10350,  10289, -1, -1, 
 20477,  10288, -2, -1, 
 30647, -50657, -3,  5, 
-50641, -20183,  5,  2, 
-30314,  50928,  3, -5, 
 20485, -40504, -2,  4, 
 50981,  20449, -5, -2, 
-50625, -40500,  5,  4, 
 30623,  40771, -3, -4, 
-30274, -40498,  3,  4, 
-20156, -50662,  2,  5, 
 30626,  20456, -3, -2, 
-20127,  10292,  2, -1, 
 40798, -20188, -4,  2, 
 10314, -50662, -1,  5, 
 50981,  30611, -5, -3, 
 20490,  50928, -2, -5, 
 30683, -20183, -3,  2, 
 51001,  20449, -5, -2, 
-50646, -20180,  5,  2, 
 40816,  10293, -4, -1, 
 10323,  40765, -1, -4, 
-20156, -20187,  2,  2, 
-50637,  10296,  5, -1, 
-20111, -20189,  2,  2, 
 40815,  10288, -4, -1, 
-20132, -40505,  2,  4, 
 40784,  10297, -4, -1, 
 50989, -40503, -5,  4, 
 30684, -50666, -3,  5, 
 40816, -50661, -4,  5, 
-20138,  30615,  2, -3, 
-40466,  40765,  4, -4, 
-40445,  20456,  4, -2, 
-30314,  30606,  3, -3, 
 40790, -40502, -4,  4, 
-20170,  30615,  2, -3, 
-20143, -10030,  2,  1, 
 10329, -50658, -1,  5, 
-10004, -40502,  1,  4, 
-30323, -20189,  3,  2, 
-50612, -30348,  5,  3, 
-20143,  40771,  2, -4, 
 40784,  20456, -4, -2, 
 20477,  30615, -2, -3, 
 40814, -10022, -4,  1, 
 10334,  40767, -1, -4, 
 10329,  10296, -1, -1, 
 40811, -20180, -4,  2, 
-40477, -30339,  4,  3, 
-20148, -10024,  2,  1, 
-40445,  20454,  4, -2, 
 50941,  20449, -5, -2, 
 10316,  50926, -1, -5, 
-50609,  20453,  5, -2, 
-40431,  30615,  4, -3, 
 50970, -10028, -5,  1, 
-20112, -50666,  2,  5, 
 30668, -10022, -3,  1, 
 20501,  50933, -2, -5, 
-50604, -10025,  5,  1, 
-20135,  30606,  2, -3, 
-20167, -20180,  2,  2, 
-30323,  30614,  3, -3, 
 30636, -40498, -3,  4, 
 40786, -50657, -4,  5, 
-50609, -30343,  5,  3, 
 40814,  50924, -4, -5, 
-20137, -50666,  2,  5, 
-50609,  50924,  5, -5, 
 40835, -30344, -4,  3, 
 10324, -30348, -1,  3, 
-20172, -10027,  2,  1, 
 50941,  50929, -5, -5, 
-50630, -40503,  5,  4, 
 40842, -10029, -4,  1, 
-50601,  10297,  5, -1, 
 51001,  20452, -5, -2, 
-40461, -50665,  4,  5, 
-40466,  50932,  4, -5, 
 30683,  10296, -3, -1, 
 40782,  40771, -4, -4, 
 -9953,  50926,  1, -5, 
-40466, -20180,  4,  2, 
 30671, -40501, -3,  4, 
 50970,  40773, -5, -4, 
-30307, -30341,  3,  3, 
 10364, -50666, -1,  5, 
-40466, -40505,  4,  4, 
 30639, -10024, -3,  1, 
 30623,  50928, -3, -5, 
 50957,  10296, -5, -1, 
-20137, -20180,  2,  2, 
 50968, -50662, -5,  5, 
-40434,  40773,  4, -4, 
 50965,  30613, -5, -3, 
 -9965, -10025,  1,  1, 
-40437,  40770,  4, -4, 
-40473,  50928,  4, -5, 
 10313,  10290, -1, -1, 
 40786,  10297, -4, -1, 
 50970,  50927, -5, -5, 
 50970,  20454, -5, -2, 
 -9981, -30339,  1,  3, 
-40437, -20183,  4,  2, 
 40811,  40769, -4, -4, 
 30671, -20182, -3,  2, 
 40790,  10289, -4, -1, 
 50965, -50663, -5,  5, 
 30676, -50662, -3,  5, 
 30644, -10028, -3,  1, 
-40474,  40767,  4, -4, 
 40819, -20188, -4,  2, 
-20132, -10029,  2,  1, 
-40437,  20447,  4, -2, 
-50617,  40772,  5, -4, 
 40790,  50931, -4, -5, 
 30623, -40498, -3,  4, 
 20496,  40765, -2, -4, 
 40806,  30611, -4, -3, 
 40802, -30348, -4,  3, 
-30291, -30347,  3,  3, 
 20500, -10030, -2,  1, 
 20517, -10030, -2,  1, 
 50994, -10027, -5,  1, 
 50949,  30613, -5, -3, 
 -9965,  10295,  1, -1, 
-30287, -10026,  3,  1, 
 40798, -20180, -4,  2, 
 50978, -40506, -5,  4, 
-40486,  10297,  4, -1, 
-20155,  40769,  2, -4, 
 10326,  40768, -1, -4, 
 40798, -10022, -4,  1, 
 50970,  50925, -5, -5, 
 20509, -50663, -2,  5, 
-30283,  40768,  3, -4, 
-40430, -10022,  4,  1, 
-20137,  40769,  2, -4, 
-20143, -40504,  2,  4, 
 30663, -10024, -3,  1, 
 30655, -40499, -3,  4, 
 -9969,  40769,  1, -4, 
 50994,  50933, -5, -5, 
 30676,  20449, -3, -2, 
 -9968, -10024,  1,  1, 
 50984, -20185, -5,  2, 
 30631,  30607, -3, -3, 
-30299, -10022,  3,  1, 
-50601, -30343,  5,  3, 
-10004, -50662,  1,  5, 
 30668, -50665, -3,  5, 
-20112,  40772,  2, -4, 
-30311,  30606,  3, -3, 
-20127, -30346,  2,  3, 
 30681, -40498, -3,  4, 
-40450, -10023,  4,  1, 
-40445,  10295,  4, -1, 
-30310, -40505,  3,  4, 
 10331,  40769, -1, -4, 
-40461,  30612,  4, -3, 
-20112, -50665,  2,  5, 
 30639,  30611, -3, -3, 
 20465,  10297, -2, -1, 
 40830, -40501, -4,  4, 
 50998, -50657, -5,  5, 
 10305,  20447, -1, -2, 
 10305,  10297, -1, -1, 
-20132,  30615,  2, -3, 
-20119, -30341,  2,  3, 
 40790,  40769, -4, -4, 
 40830, -10022, -4,  1, 
-30302,  10293,  3, -1, 
 50949, -30340, -5,  3, 
 10345, -50662, -1,  5, 
 30676, -30346, -3,  3, 
-30323,  40767,  3, -4, 
-40471,  50924,  4, -5, 
 10334, -40507, -1,  4, 
 30631,  50924, -3, -5, 
-40461, -30339,  4,  3, 
-40474,  50924,  4, -5, 
-20148,  20451,  2, -2, 
 51002,  30606, -5, -3, 
 10364,  40765, -1, -4, 
-50612, -40506,  5,  4, 
-30321, -20183,  3,  2, 
 -9963, -30344,  1,  3, 
 50966,  40769, -5, -4, 
 40799,  40765, -4, -4, 
-20112, -10030,  2,  1, 
-40431,  10288,  4, -1, 
-30283, -50662,  3,  5, 
 40798,  40770, -4, -4, 
-50625,  50930,  5, -5, 
 40810,  50928, -4, -5, 
-30286,  40774,  3, -4, 
-30331, -20188,  3,  2, 
-30283,  40774,  3, -4, 
 -9973,  50924,  1, -5, 
 30671, -20187, -3,  2, 
 10329, -30345, -1,  3, 
 40835,  20455, -4, -2, 
 10325, -20185, -1,  2, 
 30639, -20180, -3,  2, 
 40822,  50932, -4, -5, 
-50601,  10292,  5, -1, 
-20127, -30341,  2,  3);
