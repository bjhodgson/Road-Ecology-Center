library(ggplot2)
library(dplyr)

AADT = read.csv("C:\\Users\\HP\\Desktop\\AADT\\PM AADT Comparisons - NorCal.csv")

# Organize data by removing empty rows
AADT = AADT[1:13] # Subset data to exclude notes column
AADT[AADT == ""] <- NA  # Replace blank values with NA
AADT <- na.omit(AADT) # Remove NA values
any(is.na(AADT))

#AADT$HPMS.AADT = as.numeric(AADT$HPMS.AADT)
#summary(AADT$HPMS.AADT)

# Subset data by Urban location type
Urban_dist <- AADT[AADT$Location.Type == "Urban", ]
Urban_dist

# Subset data by Rural location type
Rural_dist <- AADT[AADT$Location.Type == "Rural", ]
#Remove outlier (-100)
Rural_dist <- Rural_dist %>% 
  filter(Pct.Change != -100)

# Describe Urban Pct Change
Urban_dist$Pct.Change <- as.numeric(Urban_dist$Pct.Change)
summary(Urban_dist$Pct.Change)

ggplot(data = Urban_dist, mapping = aes(x = as.numeric(Pct.Change))) +
  geom_density()

ggplot(data = Urban_dist, mapping = aes(x = as.numeric(Pct.Change))) +
  geom_boxplot()
  

# Describe Rural Pct Change
Rural_dist$Pct.Change <- as.numeric(Rural_dist$Pct.Change)
summary(Rural_dist$Pct.Change)

ggplot(data = Rural_dist, mapping = aes(x = Pct.Change)) +
  geom_density()

ggplot(data = Rural_dist, mapping = aes(x = Pct.Change)) +
  geom_boxplot()
