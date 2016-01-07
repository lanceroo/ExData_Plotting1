# Download ------------------------------------------------------------------

File <- "plot4.R" # Name file here
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

par (mfrow = c (2,2), 
     mar = c (4.1, 4.1, 4.1, 1),
     cex.lab = 1)

plot (house.sub$Global_active_power ~ house.sub$Date.Time,
      type = "l",
      xlab = "",
      ylab = "Global Active Power (kilowatts)")

plot (house.sub$Voltage ~ house.sub$Date.Time,
      type = "l",
      xlab = "datetime",
      ylab = "Voltage")


plot (house.sub$Sub_metering_1 ~ house.sub$Date.Time,
      type = "l",
      xlab = "",
      ylab = "Energy sub metering",
      col = "black")
lines (house.sub$Sub_metering_2 ~ house.sub$Date.Time,
       col = "red")
lines (house.sub$Sub_metering_3 ~ house.sub$Date.Time,
       col = "blue")
legend ("top", 
        legend = c("Sub_metering_1",
                   "Sub_metering_2", 
                   "Sub_metering_3"),
        col = c("black", "red", "blue"),
        lwd = 1,
        bty = "n",
        text.font = 1,
        cex = 1)

plot (house.sub$Global_reactive_power ~ house.sub$Date.Time,
      type = "l",
      xlab = "datetime",
      ylab = "Global_reactive_power")

# PNG ---------------------------------------------------------------------

dev.copy (png, file = "plot4.png")
dev.off()