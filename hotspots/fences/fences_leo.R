

# Fences



library(readxl)
library(dplyr)

# Load the dataset
points_100ft <- read.csv("C:\\Users\\Leo Hecht\\Documents\\Road Ecology\\Hotspot Report\\output_data\\points_table_fence.csv")

# Create a new column called "fence" and initialize it to 0
points_100ft$fence <- 0

# Identify bridge points with annl_nc >= 2
bridge_indices <- which(points_100ft$VCU == 0 & points_100ft$annl_nc >= 2)

# Loop through each bridge index and mark points for "fence"
for (i in seq_along(bridge_indices)) {
  bridge_idx <- bridge_indices[i]
  
  # Mark points sequentially on either side of the bridge until we hit another bridge
  # or until we reach 53 points (1 mile) in either direction
  start_idx <- max(1, bridge_idx - 53)
  end_idx <- min(nrow(points_100ft), bridge_idx + 53)
  
  # Initialize fence marking
  points_100ft$fence[bridge_idx] <- 1
  
  # Mark points before the bridge
  if (i == 1 || bridge_indices[i-1] < start_idx) {
    points_100ft$fence[start_idx:bridge_idx] <- 1
  } else {
    points_100ft$fence[(bridge_indices[i-1] + 1):bridge_idx] <- 1
  }
  
  # Mark points after the bridge
  if (i == length(bridge_indices) || bridge_indices[i+1] > end_idx) {
    points_100ft$fence[bridge_idx:end_idx] <- 1
  } else {
    points_100ft$fence[bridge_idx:(bridge_indices[i+1] - 1)] <- 1
  }
}

# Save the edited dataset
write.csv(points_100ft, "C:\\Users\\Leo Hecht\\Documents\\Road Ecology\\Hotspot Report\\edited_dataset_with_fence.csv", row.names = FALSE)








#new


# Load the wcc_bridges dataset
#points_100ft <- read.csv("C:\\Users\\Leo Hecht\\Documents\\Road Ecology\\Hotspot Report\\output_data\\points_table_fence.csv") # Leo path
points_100ft <- read.csv("D:\\hotspots\\fences\\output_data\\wcc_bridges.csv") # Ben path


# Create a new column called "fence" and initialize it to 0
points_100ft$fence <- 0

# Identify bridge points
bridge_indices <- which(points_100ft$VCU == 0)

# Loop through each pair of bridge indices
for (i in seq_along(bridge_indices)) {
  # Define the current bridge index
  bridge_idx <- bridge_indices[i]
  
  # Skip if it's the last bridge (no bridge after it to form a pair)
  if (i == length(bridge_indices)) {
    next
  }
  
  # Define the next bridge index
  next_bridge_idx <- bridge_indices[i + 1]
  
  # Check if there is at least one point with annl_nc > 2 between the bridges
  if (any(points_100ft$annl_nc[(bridge_idx + 1):(next_bridge_idx - 1)] > 2)) {
    # Mark points between the current and next bridge
    points_100ft$fence[bridge_idx:next_bridge_idx] <- 1
  }
}

# Save the edited dataset
#write.csv(points_100ft, "C:\\Users\\Leo Hecht\\Documents\\Road Ecology\\Hotspot Report\\dataset_with_fence_processed.csv", row.names = FALSE) # Leo path
write.csv(points_100ft, "D:\\hotspots\\fences\\output_data\\hotspot_fences.csv", row.names = FALSE) # Ben path

fences_df <- points_100ft %>%
  filter(fence == 1) # Select points to fence

write.csv(fences_df, "D:\\hotspots\\fences\\output_data\\fences_df.csv", row.names = FALSE) # Ben path



# Summarize miles and roadkills per hotspot
summary_df <- fences_df %>%
  group_by(new_sequence) %>%
  summarise(
    num_records = n(),
    mean_annl_nc = mean(annl_nc, na.rm = TRUE)
  ) %>%
  mutate(
    length_miles = num_records * 100 / 5280,
