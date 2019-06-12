library(gapminder)
library(tidyverse)

install.packages("wesanderson")


gap <- gapminder


str(gap)

gap %>% 
  filter(continent == "Europe") %>% 
  select(contains("pop"), contains("year")) %>% View
  ggplot(aes(x = year, y = lifeExp, color = country)) + geom_line() +
  scale_color_viridis_d()

#comment

#select columns, filter rows, names, - names, 1:4

gap_africa <- gap %>% 
  filter(continent == "Africa") %>% 
  select(lifeExp, country, year)
str(gap_africa)
#don't pipe in the function

gap_sum <- gap %>% 
  group_by(continent) %>%
  summarise(mean_life_exp = mean(lifeExp), 
            min_life_exp = min(lifeExp))

write_csv(gap_sum,"gap_sum.csv")
