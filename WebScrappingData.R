library(rvest)
countries = c('Germany', 'Poland', 'Norway', 'France')
countrycode = c('CTY|10Y1001A1001A83F!CTY|10Y1001A1001A83F',
                'CTY|10YPL-AREA-----S!CTY|10YPL-AREA-----S',
                'CTY|10YNO-0--------C!CTY|10YNO-0--------C',
                'CTY|10YFR-RTE------C!CTY|10YFR-RTE------C'
                )

data <- data.frame(date = c(), time = c(), totalLoad = c())

for (Year in 2015:2021){
  for (Month in 1:12){
    if (Month %in% c(1,3,5,7,8,10,12)){
      max_days = 31
    } else if (Month %in% c(4,6,9,11)){
      max_days = 30
    } else {
      if (Year %in% c(2016, 2020)){
        max_days = 29
      } else {
        max_days = 28
      }
    }
    for (day in 1:max_days){
      mm = Month
      dd = day
      if (Month < 10) { mm = paste0("0",Month) }
      if (day < 10) { dd = paste0("0",day) }
      for (i in 1:4){
        link = paste0("https://transparency.entsoe.eu/load-domain/r2/totalLoadR2/show?name=&defaultValue=false&viewType=TABLE&areaType=CTY&atch=false&dateTime.dateTime=",dd,".",mm,".",Year,"+00:00|UTC|DAY&biddingZone.values=",countrycode[i],"&dateTime.timezone=UTC&dateTime.timezone_input=UTC")
        page <- read_html(link)
        
        time = page %>% html_nodes(".first") %>% html_text()
        total_load = page %>% html_nodes("..dv-value-cell+ .dv-value-cell") %>% html_text()
      data <- rbind(data, cbind(countries[i], paste0(dd,"-",mm,"-",Year), time, total_load))
      break
      }
    }
  }
}
colnames(data) <- c("Country", "Date", "time", "totalLoad")

write.csv(data, "Electricity_data.csv")




link = paste0("https://transparency.entsoe.eu/load-domain/r2/totalLoadR2/show?name=&defaultValue=false&viewType=TABLE&areaType=CTY&atch=false&dateTime.dateTime=",'01',".",'01',".",'2015',"+00:00|UTC|DAY&biddingZone.values=",'CTY|10Y1001A1001A83F!CTY|10Y1001A1001A83F',"&dateTime.timezone=UTC&dateTime.timezone_input=UTC")
page <- read_html(link)

time = page %>% html_nodes(".first") %>% html_text()
total_load = page %>% html_nodes(".dv-value-cell+ .dv-value-cell , .dv-value-cell+ .dv-value-cell .data-view-detail-link") %>% html_text()
data <- rbind(data, cbind(countries[i], paste0(dd,"-",mm,"-",Year), time, total_load))









  
