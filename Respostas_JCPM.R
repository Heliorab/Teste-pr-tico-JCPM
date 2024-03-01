### RESPOSTAS ###

#1- Quantas assinaturas foram realizadas no período?

# Total de eventos que geraram assinaturas
assinantes <- bd_completo %>% filter(paywall_subscription_status == "'success'")

# Garantindo que não terão assinaturas repetidas
assinantes$tag <- NULL
assinaturas_distintas <- distinct(assinantes)

# Resultado
paste("Foram realizadas", nrow(assinaturas_distintas), "assinaturas")

#2- Quantos bloqueios foram realizados?

# Data frame só com os bloqueios
block <- bd_completo %>% filter(signinwall == "'block'")

# Garantindo que não terão bloqueios repetidos
block$tag <- NULL
block$user_age_range <- NULL
block$user_gender <- NULL
block_distintos <- distinct(block)

# Resultados
paste("Foram bloqueados", nrow(block_distintos), "acessos")

#3- Qual o tipo de conteúdo que mais converteu assinaturas?

# Total de eventos que geraram assinatura
assinantes <-  bd_completo %>% filter(paywall_subscription_status == "'success'")

# Tags relacionadas às assinaturas
tags_assinantes <- assinantes %>% count(tag)

# Descrição da distribuição das tags
summary(tags_assinantes)

# Visualização das mais frequentes
View(tags_assinantes)

#4- Que tipo de conteúdo gerou mais bloqueios?

# Todos eventos que geraram bloqueios
todos_bloqueios <- bd_completo %>% filter(signinwall == "'block'")

# Tags associadas a bloqueios
tags_bloqueios <- todos_bloqueios %>%  count(tag)

# Descrição da distribuição das tags
summary(tags_bloqueios)

# Visualização das mais frequentes
View(tags_bloqueios)

#5- Qual a taxa de conversão?
contagem_deviceID <- bd_completo %>% count(device_id)
taxa <- nrow(assinantes)/nrow(contagem_deviceID)

# Resultado
taxa

#6- Qual o perfil de quem leu? Existe uma diferença de perfil entre leitores normais e assinantes?

#Autores mais lidos entre os assinantes
autores_ass <- assinaturas_distintas %>% count(author)
#Visualização
View(autores_ass)

# Autores mais lido entre os nao assinantes

# Dados que contem somente nao assinantes
nao_assinantes <- bd_completo %>% filter(paywall_subscription_status != "'success'")

# Garantindo a nao duplicidade
nao_assinantes$tag <- NULL
nao_assinantes_dist <- distinct(nao_assinantes)

# Resultado
autores_N_ass <- nao_assinantes_dist %>%count(author)

# Visualização
View(autores_N_ass)

# Tags frequentes entre assinantes
freq_tags_ass <- assinantes %>% count(tag)
View(freq_tags_ass)

#tags frequentes entre nao assinantes
nao_assinantes <- bd_completo %>% filter(paywall_subscription_status != "'success'")
# Com dados totais
freq_tags_n_ass <- nao_assinantes %>% count(tag)
View(freq_tags_n_ass)

# Utilizando uma amostra aleatoria
amostra_nao_ass <- nao_assinantes %>% 
  sample_n(100, replace = FALSE)
freq_tags_n_ass_aa <- amostra_nao_ass %>% count(tag)
View(freq_tags_n_ass_aa)

# Range idade assinantes
barplot(table(assinaturas_distintas$user_age_range), main = "Assinantes", xlab = "Idade", ylab = "Frequência")
# Range idade nao assinantes
barplot(table(nao_assinantes_dist$user_age_range), main = "Não assinantes", xlab = "Idade", ylab = "Frequência")

# Genero dos assinantes
barplot(table(assinaturas_distintas$user_gender), main = "Assinantes", ylab = "Frequência")
# Genero dos nao assinantes
barplot(table(nao_assinantes_dist$user_gender), main = "Não assinantes", ylab = "Frequência")

# Referer dos assinantes
refere_ass <- assinaturas_distintas %>% count(referer)
View(refere_ass)
# Referer dos nao assinantes
referer_n_ass <- nao_assinantes_dist %>% count(referer)
View(referer_n_ass)

#7- Quantos bloqueios, em média, um usuário leva antes de realizar uma assinatura?

# Lista com os device_ID dos assinantes
deviceID_ass <- as.list(assinaturas_distintas$device_id)

# LInhas dos bloqueados antes de realizar uma assinatura
bloq_ass <- block_distintos %>% 
  filter(device_id %in% deviceID_ass)

View(bloq_ass) 


### Extra ###

# Quais os planos assinados
planos_assinados <- assinaturas_distintas %>% count(paywall_subscription_product_name)

# Histórico dos assinantes
# df auxiliar para criar um historico dos assinantes
bd_completo2 <- bd_completo %>%
  select(-c(tag, user_gender, user_age_range))

# Garantindo que não há duplicatas
bd_distinto <- distinct(bd_completo2)

# historico completo de acesso dos assinantes
historico_assinantes <- nao_assinantes_dist %>% 
  filter(device_id %in% deviceID_ass)
historico_assinantes <- rbind(historico_assinantes, assinaturas_distintas)

# Visualização
table(historico_assinantes$device_id)