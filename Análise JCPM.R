library(readr)
library(dplyr)
library(jsonlite)
library(psych)

bd1 <- read_csv("teste prático JCPM/585696c7-537d-45bc-8b93-e6fecadd1e63.csv")
bd2 <- read_csv("teste prático JCPM/77548291-5a08-41b6-a0b8-819889a5dfc7.csv")

#Juntando os dois conjuntos de dados
bd_completo <- rbind(bd1, bd2)

# Adptando a coluna metadata pra o tipo JSON
bd_completo$metadata <- gsub('=', '":"', bd_completo$metadata)
bd_completo$metadata <- gsub(', ', '", "', bd_completo$metadata)
bd_completo$metadata <- gsub(')', '"}', bd_completo$metadata)
bd_completo$metadata <- gsub('AL"}', 'AL)', bd_completo$metadata)
bd_completo$metadata <- paste0('{"', bd_completo$metadata)

# Transformando a coluna Metadata em varias colunas e adicionando ao bd
bd_completo$metadata <- lapply(bd_completo$metadata, fromJSON)
bd_completo <- cbind(bd_completo, do.call(rbind, bd_completo$metadata))

### Conhecendo os dados ###

# Para cada categoria, contar a frequência de ocorrência

#contagem_amp_url <- bd_completo %>% count(amp_url)
#contagem_api_event <- bd_completo %>% count(api_event)
#contagem_api_type <- bd_completo %>% count(api_type)
contagem_author <- bd_completo %>% count(author)
#contagem_brand <- bd_completo %>% count(brand)
#contagem_categories <- bd_completo %>% count(categories)
#contagem_digital_access <- bd_completo %>% count(digital_access)
contagem_event <- bd_completo %>% count(event)
#contagem_facebook_uid <- bd_completo %>% count(facebook_uid)
#contagem_page_info_yy <- bd_completo %>% count(page_info_yy)
contagem_paywall_selected_plan <- bd_completo %>% count(paywall_selected_plan)
contagem_paywall_selected_plan_type <- bd_completo %>% count(paywall_selected_plan_type)
contagem_paywall_subscription_payment_type <- bd_completo %>% count(paywall_subscription_payment_type)
contagem_paywall_subscription_product_id <- bd_completo %>% count(paywall_subscription_product_id)
contagem_paywall_subscription_product_name <- bd_completo %>% count(paywall_subscription_product_name)
contagem_paywall_subscription_status <- bd_completo %>% count(paywall_subscription_status)
#contagem_price <- bd_completo %>% count(price)
#contagem_profile <- bd_completo %>% count(profile)
contagem_screen <- bd_completo %>% count(screen)
contagem_signinwall <- bd_completo %>% count(signinwall)
contagem_signinwall_loginstatus <- bd_completo %>% count(signinwall_loginstatus)
#contagem_sku <- bd_completo %>% count(sku)
#contagem_store <- bd_completo %>% count(store)
#contagem_subcategories <- bd_completo %>% count(subcategories)
contagem_tags <- bd_completo %>% count(tags)
#contagem_title <- bd_completo %>% count(title)
#contagem_user_info_xx <- bd_completo %>% count(user_info_xx)

# As colunas 1,2,3,5,6,7,9,10,17,18,22,23,24,26,27 só tem valores "none"
# Vamos removê-las para melhor visualização
bd_completo <- bd_completo %>%
  select(-c(11,12,13,15,16,17,19,20,27,28,32,33,34,36,37))
