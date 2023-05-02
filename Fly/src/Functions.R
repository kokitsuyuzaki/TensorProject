library("guidedPLS")
library("Rtsne")
library("ggplot2")
library("reshape2")
library("VennDiagram")
library("tagcloud")
library("readxl")
library("writexl")
library("enrichR")

group <- c("naïve normal", "naïve claustrophobia",
"shock highly claustrophobia", "shock mildly claustrophobia",
"shock no claustrophobia")

deg.genes <- c("CR11538", "Lsp2", "CG34166", "Nmdmc", "CG10924", "CG16758", "CG5966", "Nplp2", "CG11089", "CG16713", "UK114", "CG3775", "CG34424", "CR44108", "ade5", "v", "CG2736", "CG3011", "CG44006", "CG11400", "Iris", "CR43417", "CG9914", "CG5171", "CR45701", "Cyp4ac2", "CG11899", "Gip", "CG31075", "Hf", "CG8654", "CR45485", "CG7322", "Cyp6w1", "CG4019", "fbp", "CG17108", "Est-6", "CG9547", "Eip71CD", "CG14400", "GNBP3", "CG12262", "CG18547", "ade2", "CG10361", "Gel", "CG7457", "CG2145", "mdy", "CG16712", "yellow-f2", "CG3609", "yip2", "CG10516", "T3dh", "CG31769", "Oat", "CG30151", "comm2", "CG10824", "Cyp4e2", "alpha-Est7", "CG6543", "CG2107", "CR44969", "CG11309", "CG4847", "LM408", "Spn42Dd", "CG8525", "CG6287", "CG15117", "Got2", "Cyp9b2", "CR45952", "glob1", "SPE", "CG5167", "CG5390", "CG31937", "GstE3", "AdipoR", "CR44021", "Ugt35b", "sut1", "CG7834", "ry", "Tret1-1", "CG7461", "psh", "CG11334", "tsl", "CG3835", "Mtpalpha", "UGP", "Tal", "CG1516", "Ent2", "Idgf4", "Gs1", "Mdh1", "CG31326", "path", "whd", "skap", "CG5778", "CG4721", "colt", "Aldh", "Ef1alpha48D", "nec", "Idh", "CG11739", "eIF-5A", "Adgf-D", "Fdh", "asparagine-synthetase", "Etf-QO", "CG6357", "Acsl", "CG17841", "ScpX", "CG1774", "GstS1", "Cyp6a23", "Pdxk", "CG15739", "Dhpr", "Pex5", "CG11122", "CR44807", "Pal1", "CG32815", "CG44774", "kst", "Surf4")

