path = '/Users/arthurmello/Library/Mobile Documents/com~apple~CloudDocs/Geral/Outros/Portfólio/Linear Regression/'
data = read.csv(paste(path,'kc_house_data.csv', sep = ""))

colnames(data)

attach(data)
plot(sqft_living,price)