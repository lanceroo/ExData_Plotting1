# Download ------------------------------------------------------------------

File <- "plot1.R" # Name file here
Files <- list.files (path = file.path ("~"),
                     recursive=T,
                     include.dirs=T)
Path.file <- names (unlist (sapply (Files,
                                    grep,
                                    pattern = File))[1])
Dir.wd <- paste (c (path.expand ("~"), 
                    dirname (Path.file)), 
                 collapse = "/")
setwd (Dir.wd)

file.url <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"        

if (!file.exists ("household_power_consumption.txt")) {
        if (!file.exists ("exdata-data-household_power_consumption.zip")) {
                download.file (file.url, destfil = "exdata-data-household_power_consumption.zip")
        }
        unzip ("exdata-data-household_power_consumption.zip")
}
        
# Import ------------------------------------------------------------------

house.file <- "household_power_consumption.txt"

headers <- read.csv (house.file,
                     sep = ";",
                     nrows = 1)

house.sub <- read.csv (house.file, 
                       sep=";", 
                       stringsAsFactors = FALSE,
                       na.strings = "?",
                       skip = 66637, ## Start on Feb 1, 2007
                       nrows = 2880, ## End on Feb 2, 2007
                       header = FALSE,
                       col.names = colnames (headers))

house.sub <- transform (house.sub, 
                        Date.Time = paste (house.sub$Date, 
                                           house.sub$Time))

house.sub$Date <- as.Date (house.sub$Date,
                           "%d/%m/%Y")

house.sub$Date.Time <- strptime(house.sub$Date.Time, 
                                format = "%d/%m/%Y %H:%M:%S")

house.sub <- data.frame (house.sub[, 1:2], 
                         Date.Time =house.sub[, 10], 
                         house.sub[, 3:9])

# Plot --------------------------------------------------------------------

with (house.sub, hist (Global_active_power,
                       main = "Global Active Power",
                       col = "red",
                       xlab = "Global Active Power (kilowatts)"))

# PNG ---------------------------------------------------------------------

dev.copy (png, file = "plot1.png")
dev.off()