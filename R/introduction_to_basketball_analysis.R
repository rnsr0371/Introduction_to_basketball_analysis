#必要なライブラリのインポート
library(tidyverse)

#データのインポート
teams=read_csv("../data/teams.csv")
boxscore=read_csv("../data/games_boxscore_202021.csv")

#teamsからB1_202021シーズンのTeamIdを取り出す。
#この作業はboxscoreからB1の選手のデータを取り出すのに必要。
teams=teams %>% filter(.,League=="B1") %>% filter(.,Season=="2020-21")

#teamsとboxscoreをTeamIdでjoinして、B1の選手だけを抜き出す
boxscore=teams %>% left_join(boxscore,by="TeamId")

#選手のシーズン平均のスタッツを作るために、Playerでgroupbyし、平均と標準偏差を集計
data=boxscore %>% group_by(.,Player) %>% summarise(avg=mean(PTS),std=sd(PTS),MIN=mean(MIN))

#変動係数(CV)を算出して、dataに新たな列として追加する。
data=data %>% mutate(CV=std/avg)

#平均出場時間が20分以上の選手で、変動係数が高い選手TOP10を表示する
data %>% filter(MIN>=20) %>% arrange(desc(CV)) %>% head(10)

#平均得点が10点以上で、変動係数が高い選手TOP10を表示する
data %>% filter(avg>=10) %>% arrange(desc(CV)) %>% head(10)

#出場時間が20分以上で変動係数が低い選手TOP10を表示する
data %>% filter(MIN>=20) %>% arrange(CV) %>% head(10)






