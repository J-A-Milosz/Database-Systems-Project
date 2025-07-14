# Biblioteki:
library(tools)
library(shiny)
library(DBI)
library(RPostgreSQL)
library(RPostgres)
library(shinyjs)
library(DT)
library(dplyr)
library(shinyWidgets)
library(stringr)


# Dane uzytkownika:
db <- "baza_zoo_w_sql"
db_host <- "localhost"
db_port <- 5432
db_user <- "postgres"
db_pass <- "zoo123" # haslo


# Laczenie z baza danych: 
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = db,
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_pass
)


# Funkcja do wczytywania tabeli z bazy danych:
load_table <- function(table_name) {
  query <- sprintf("SELECT * FROM %s", table_name)
  data <- dbGetQuery(con, query)
  return(data)
}


# Funkcja do wczytywania widokow z bazy danych:
load_viev <- function(viev_name) {
  query <- sprintf("SELECT * FROM %s", viev_name)
  data <- dbGetQuery(con, query)
  return(data)
}


# Funkcja do zczytywania kolumn potrzebnych do dodawania krotek:
important_columns <- function(table_name, col_names){
  if (table_name == "opiekunowie"){
    return(setdiff(col_names, "id_opiekuna"))
  } else if (table_name == "sektory"){
    return(setdiff(col_names, "id_sektora"))
  } else if (table_name == "klatki"){
    return(setdiff(col_names, "id_klatki"))
  } else if (table_name == "zwierzeta"){
    return(setdiff(col_names, "id_zwierzecia"))
  } else if (table_name == "weterynarze"){
    return(setdiff(col_names, "id_weterynarza"))
  } else if (table_name == "sponsorzy"){
    return(setdiff(col_names, "id_sponsora"))
  } else {
    return(col_names)
  }
}


# Funkcja zwracajaca PK:
pk_function <- function(table_name){
  if (table_name == "opiekunowie"){
    return("id_opiekuna")
  } else if (table_name == "sektory"){
    return("id_sektora")
  } else if (table_name == "rodzaje_klatek"){
    return("rodzaj_klatki")
  } else if (table_name == "klatki"){
    return("id_klatki")
  } else if (table_name == "gatunki"){
    return("gatunek")
  } else if (table_name == "zwierzeta"){
    return("id_zwierzecia")
  } else if (table_name == "rozpiska_godzinowa"){
    return("pora")
  } else if (table_name == "dostawy_pozywienia"){
    return("rodzaj_jedzenia")
  } else if (table_name == "karmienie"){
    return(list("id_klatki", "pora_karmienia"))
  } else if (table_name == "czyszczenie_klatek"){
    return(list("id_klatki", "pora_czyszczenia"))
  } else if (table_name == "weterynarze"){
    return("id_weterynarza")
  } else if (table_name == "badania"){
    return("id_badania")
  } else if (table_name == "sponsorzy"){
    return("id_sponsora")
  } else if (table_name == "donacje"){
    return("czas_donacji")
  } else if (table_name == "sklep"){
    return(list("gatunek", "rodzaj_pamiatki"))
  }
}


# Funkcja do dodawania krotek:
insert_record <- function(table_name, values) {
  
  col_names <- important_columns(table_name, 
                                 colnames(load_table(table_name)))
  
  query <- sprintf("INSERT INTO %s (%s) VALUES (%s)", 
                   table_name, 
                   paste(col_names, collapse = ', '), 
                   paste(sprintf("'%s'", values[col_names]), collapse = ', '))
  tryCatch(
    {
      dbExecute(con, query)
    },
    error = function(e) {
      
      if (grepl("duplicate key value violates unique constraint", 
                e$message)) {showModal(modalDialog(
                  title = "Blad",
                  'Jedna z kolumn jest Kluczem Glownym lub jest Unique.'
                ))
      } else if (grepl("Klatka nie moze byc nakarmiona o tej porze, trwa czyszczenie!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad", 
                           "Klatka nie moze byc nakarmiona o tej porze, trwa czyszczenie!"
                         ))
      } else if (grepl("Klatka nie moze byc czyszczona o tej porze, trwa karmienie!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Klatka nie moze byc czyszczona o tej porze, trwa karmienie!"
                         ))
      } else if (grepl("Dwie klatki nie moga byc karmione jednoczesnie przez tego samego opiekuna!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Dwie klatki nie moga byc karmione jednoczesnie przez tego samego opiekuna!"
                         ))
      } else if (grepl("Dwie klatki nie moga byc czyszczone jednoczesnie przez tego samego opiekuna!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Dwie klatki nie moga byc czyszczone jednoczesnie przez tego samego opiekuna!"
                         ))
      } else if (grepl("Klatka nie moze byc czyszczona o tej porze, ten opiekun wlasnie karmi!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Klatka nie moze byc czyszczona o tej porze, ten opiekun wlasnie karmi!"
                         ))
      } else if (grepl("Klatka nie moze byc karmiona o tej porze, ten opiekun wlasnie czysci!", 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Klatka nie moze byc karmiona o tej porze, ten opiekun wlasnie czysci!"
                         ))
      } else if (grepl("Ten opiekun nie moze zostac kierownikiem!",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Ten opiekun nie moze zostac kierownikiem!"
                         ))
      } else if (grepl("Nie mozna wybrac daty zatrudnienia z przyszlosci!",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna wybrac daty zatrudnienia z przyszlosci!"
                         ))
      } else if (grepl("'Nie mozna wybrac daty urodzin z przyszlosci!",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna wybrac daty urodzin z przyszlosci!"
                         ))
      } else if (grepl("Nie mozna wybrac daty i godziny badania z przyszlosci!",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna wybrac daty i godziny badania z przyszlosci!"
                         ))
      } else if (grepl("Nie mozna wybrac daty i godziny donacji z przyszlosci!",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna wybrac daty i godziny donacji z przyszlosci!"
                         ))
      } else if (grepl("invalid input syntax for type date",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Data powinna miec format: YYYY-MM-DD"
                         ))
      } else if (grepl("invalid input syntax for type timestamp",
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Dokladna data powinna miec format: YYYY-MM-DD HH:MM:SS"
                         ))
      } else if (grepl('new row for relation "rozpiska_godzinowa" violates check constraint "rozpiska_godzinowa_pora_check"',
                       e$message)){showModal(
                         modalDialog(
                           title = "Blad",
                           "Godzina powinna miec format: HH:MM"
                         ))
      } else {
        showModal(modalDialog(
          title = "Blad",
          sprintf("%s", e$message)
        )) 
      }
    }
  )
}


# Funkcja do usuwania krotki:
remove_rec <- function(table_name, values, col_name){
  table_data <- load_table(table_name)
  if (table_name %in% c("karta_badania", "operacje_na_klatkach", 
                        "zajecia_opiekunow")){
    showModal(modalDialog(
      title = "Blad",
      "Nie mozna uswac krotek z widokow."
    ))
  } 
  else if (length(colnames(table_data)) == 1){
    query <- sprintf("DELETE FROM %s WHERE %s = '%s';",
                     table_name,
                     pk_function(table_name),
                     values)
  }
  else if (length(pk_function(table_name)) == 1 & length(colnames(table_data)) != 1){
    query <- sprintf("DELETE FROM %s WHERE %s = '%s';", 
                     table_name,
                     pk_function(table_name),
                     values[pk_function(table_name)])
  } else { 
    query <- sprintf("DELETE FROM %s WHERE %s = '%s' AND %s = '%s';", 
                     table_name,
                     pk_function(table_name)[[1]],
                     values[pk_function(table_name)[[1]]],
                     pk_function(table_name)[[2]],
                     values[pk_function(table_name)[[2]]])
  }
  tryCatch(
    {
      dbExecute(con, query)
    },
    error = function(e) {
      if (str_detect(e$message, "invalid input syntax for type integer") || str_detect(e$message, "Expected string vector of length"))
      {showModal(modalDialog(
        title = "Blad",
        "Nalezy wybrac dokladnie jedna krotke."
      ))
      } else if (grepl('update or delete on table "opiekunowie" violates foreign key constraint "sektory_id_kierownika_fkey" on table "sektory"', 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad", 
                           "Nie mozna zwolnic aktywnego kierownika sektora."
                         ))
      } else if (grepl('update or delete on table "opiekunowie" violates foreign key constraint "karmienie_id_opiekuna_fkey" on table "karmienie"', 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna zwolnic pracownika, ktory ma przydzielone zdanie (karmienie)."
                         ))
      } else if (grepl('update or delete on table "opiekunowie" violates foreign key constraint "czyszczenie_klatek_id_opiekuna_fkey" on table "czyszczenie_klatek"', 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna zwolnic pracownika, ktory ma przydzielone zdanie (czyszczenie)."
                         ))
      } else if (grepl('update or delete on table "rodzaje_klatek" violates foreign key constraint "klatki_rodzaj_klatki_fkey" on table "klatki"', 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna usunac rodzaju klatki, jesli nadal mamy w zoo klatki tego typu."
                         ))
      } else if (grepl('update or delete on table "klatki" violates foreign key constraint "zwierzeta_id_klatki_fkey" on table "zwierzeta"', 
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna usunac klatki nie usuwajac wczesniej zniej zwierzat."
                         ))
      } else if (grepl('update or delete on table "gatunki" violates foreign key constraint "zwierzeta_gatunek_fkey" on table "zwierzeta"',  # gatunki
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna usunac gatunku z wykazu gatunkow, jesli nadal mamy w zoo zwierze tego gatunku."
                         ))
      } else if (grepl('update or delete on table "gatunki" violates foreign key constraint "sklep_gatunek_fkey" on table "sklep"',  
                       e$message)) {showModal(
                         modalDialog(
                           title = "Blad",
                           "Nie mozna usunac gatunku z wykazu gatunkow, jesli nadal pamiatki zwiazane z tym gatunkiem."
                         ))
      }  
      else {
        showModal(modalDialog(
          title = "Blad",
          sprintf("%s", e$message)
        ))
      }
    }
  )
}




# UI:
ui <- fluidPage(
  
  setBackgroundColor(color = "lightyellow",
                     gradient = "linear",
                     direction = "bottom"),
  titlePanel("Baza Danych Zoo"),
  sidebarLayout(
    sidebarPanel(
      tags$style(".well {background-color:lightgreen;}"),
      selectInput("table", "Wybierz tabele:", choices = c("opiekunowie", 
                                                          "sektory", 
                                                          "rodzaje_klatek", 
                                                          "klatki", 
                                                          "gatunki", 
                                                          "zwierzeta", 
                                                          "rozpiska_godzinowa", 
                                                          "dostawy_pozywienia", 
                                                          "karmienie", 
                                                          "czyszczenie_klatek", 
                                                          "weterynarze", 
                                                          "badania", 
                                                          "sponsorzy", 
                                                          "donacje", 
                                                          "sklep")
      ),
      actionButton("load_data", "Wczytaj dane"
      ),
      conditionalPanel(
        condition = "input.table_output_rows_selected > 0",
        uiOutput("delete"),
        actionButton("remove_record", "Usun krotke", style = "background-color: red")
      ),
      selectInput("viev", "Wybierz widok:", choices = c("karta_badania", 
                                                        "operacje_na_klatkach", 
                                                        "zajecia_opiekunow")
      ),
      actionButton("load_viev", "Wczytaj widok"
      )
    ),
    mainPanel(
      DTOutput("table_output"),
      tags$hr(),
      conditionalPanel(
        condition = "input.load_data > 0",
        actionButton("add_record", "Dodaj nowa krotke", style = "background-color: lightgreen")
      ),
      conditionalPanel(
        condition = "input.add_record > 0",
        uiOutput("form"),
        actionButton("save_record", "Zapisz", style = "background-color: lightgreen")
      )
    )
  )
)


# Server:
server <- function(input, output, session) {
  
  
  # Widoki i ich ladowanie:
  observeEvent(input$load_viev, {
    viev_name <- input$viev
    data <- load_viev(viev_name)
    output$table_output <- renderDT({
      datatable(data, options = list(pageLength = 20))
    })
  })
  
  
  # Tabele i ich ladowanie:
  observeEvent(input$load_data, {
    table_name <- input$table
    data <- load_table(table_name)
    output$table_output <- renderDT({
      datatable(data, options = list(pageLength = 20))
    })
  })
  
  
  # Formularz dla dodawania krotki:
  output$form <- renderUI({
    table_name <- input$table
    table_data <- load_table(table_name)
    col_names <- important_columns(table_name,
                                   colnames(table_data))
    
    if (table_name == "opiekunowie"){
      inputs <- list(textInput(col_names[1], "Imie:"),
                     textInput(col_names[2], "Nazwisko:"),
                     textInput(col_names[3], "Pracuje od:"),  
                     selectInput(col_names[4], "Czy moze byc kierownikiem sektora?",
                                 choices = c("true", "false"),
                                 selected = "true")
      )
    } 
    else if (table_name == "sektory"){
      potencjalni_kierow_sql <- "SELECT id_opiekuna FROM opiekunowie WHERE czy_moze_byc_kierownikiem = true;"
      potencjalni_kierow_lst <- dbGetQuery(con, potencjalni_kierow_sql)
      inputs <- list(selectInput(col_names[1], "Id kierownika:",
                                 choices = potencjalni_kierow_lst,
                                 selected = min(potencjalni_kierow_lst)),
                     textInput(col_names[2], "Klimat:"),
                     selectInput(col_names[3], "Czy sektor jest zadaszony?",
                                 choices = c("true", "false"),
                                 selected = "true")
      )
    } 
    else if (table_name == "rodzaje_klatek"){
      inputs <- list(textInput(col_names[1], "Rodzaj klatki:")
      )
    } 
    else if (table_name == "klatki"){
      id_sektorow_sql <- "SELECT id_sektora FROM sektory;"
      id_sektorow_r <- dbGetQuery(con, id_sektorow_sql)
      rodzaje_klatek_sql <- "SELECT rodzaj_klatki FROM rodzaje_klatek;"
      rodzaje_klatek_r <- dbGetQuery(con, rodzaje_klatek_sql)
      inputs  <- list(selectInput(col_names[1], "Id sektora:",
                                  choices = id_sektorow_r,
                                  selected = min(id_sektorow_r)),
                      selectInput(col_names[2], "Rodzaj klatki:",
                                  choices = rodzaje_klatek_r,
                                  selected = rodzaje_klatek_r[1])
      )
    } 
    else if (table_name == "gatunki"){
      inputs <- list(textInput(col_names[1], "Gatunek:")
      )
    } 
    else if (table_name == "zwierzeta"){
      id_klatek_sql <- "SELECT id_klatki FROM klatki;"
      id_klatek_r <- dbGetQuery(con, id_klatek_sql)
      gatunki_sql <- "SELECT gatunek FROM gatunki;"
      gatunki_r <- dbGetQuery(con, gatunki_sql)
      inputs <- list(selectInput(col_names[1], "Id klatki:",
                                 choices = id_klatek_r,
                                 selected = min(id_klatek_r)),
                     textInput(col_names[2], "Imie:"),
                     selectInput(col_names[3], "Gatunek:",
                                 choices = gatunki_r,
                                 selected = gatunki_r[1]),
                     selectInput(col_names[4], "Plec:",
                                 choices = c("samica", "samiec"),
                                 selected = "samica"),
                     textInput(col_names[5], "Pochodzenie:"),
                     textInput(col_names[6], "Data urodzin:")
      )
    } 
    else if (table_name == "rozpiska_godzinowa"){
      inputs <- list(textInput(col_names[1], "Godzina:")
      )
    } 
    else if (table_name == "dostawy_pozywienia"){
      inputs <- list(textInput(col_names[1], "Rodzaj jedzenia:"),
                     selectInput(col_names[2], "Dzien dostawy:",
                                 choices = c("poniedzialek", "wtorek", "sroda", 
                                             "czwartek", "piatek",  "sobota", 
                                             "niedziela"),
                                 selected = "poniedzialek")
      )
    } 
    else if (table_name == "karmienie"){
      id_klatek_sql <- "SELECT id_klatki FROM klatki;"
      id_klatek_r <- dbGetQuery(con, id_klatek_sql)
      pory_karmienia_sql <- "SELECT pora FROM rozpiska_godzinowa;"
      pory_karmienia_r <- dbGetQuery(con, pory_karmienia_sql)
      id_opiekunow_sql <- "SELECT id_opiekuna FROM opiekunowie;"
      id_opiekunow_r <- dbGetQuery(con, id_opiekunow_sql)
      rodzaje_jedzenia_sql <- "SELECT rodzaj_jedzenia FROM dostawy_pozywienia;"
      rodzaje_jedzenia_r <- dbGetQuery(con, rodzaje_jedzenia_sql)
      inputs <- list(selectInput(col_names[1], "Id klatki:",
                                 choices = id_klatek_r,
                                 selected = min(id_klatek_r)),
                     selectInput(col_names[2], "Pora karmienia:",
                                 choices = pory_karmienia_r,
                                 selected = pory_karmienia_r[1]),
                     selectInput(col_names[3], "Id opiekuna:",
                                 choices = id_opiekunow_r,
                                 selected = min(id_opiekunow_r)),
                     selectInput(col_names[4], "Rodzaj jedzenia:",
                                 choices = rodzaje_jedzenia_r,
                                 selected = rodzaje_jedzenia_r[1])
      )
    } 
    else if (table_name == "czyszczenie_klatek"){
      id_klatek_sql <- "SELECT id_klatki FROM klatki;"
      id_klatek_r <- dbGetQuery(con, id_klatek_sql)
      pory_czyszczenia_sql <- "SELECT pora FROM rozpiska_godzinowa;"
      pory_czyszczenia_r <- dbGetQuery(con, pory_czyszczenia_sql)
      id_opiekunow_sql <- "SELECT id_opiekuna FROM opiekunowie;"
      id_opiekunow_r <- dbGetQuery(con, id_opiekunow_sql)
      inputs <- list(selectInput(col_names[1], "Id klatki:",
                                 choices = id_klatek_r,
                                 selected = min(id_klatek_r)),
                     selectInput(col_names[2], "Pora czyszczenia:",
                                 choices = pory_czyszczenia_r,
                                 selected = pory_czyszczenia_r[1]),
                     selectInput(col_names[3], "Id opiekuna:",
                                 choices = id_opiekunow_r,
                                 selected = min(id_opiekunow_r))
      )
    } 
    else if (table_name == "weterynarze"){
      inputs <- list(textInput(col_names[1], "Imie:"),
                     textInput(col_names[2], "Nazwisko:"),
                     textInput(col_names[3], "Specjalizacja:")
      )
    } 
    else if (table_name == "badania"){
      id_weterynarzy_sql <- "SELECT id_weterynarza FROM weterynarze;"
      id_weterynarzy_r <- dbGetQuery(con, id_weterynarzy_sql)
      id_zwierzat_sql <- "SELECT id_zwierzecia FROM zwierzeta;"
      id_zwierzat_r <- dbGetQuery(con, id_zwierzat_sql)
      inputs <- list(textInput(col_names[1], "Data i czas badania (Id Badania):"),
                     selectInput(col_names[2], "Id weterynarza:",
                                 choices = id_weterynarzy_r,
                                 selected = min(id_weterynarzy_r)),
                     selectInput(col_names[3], "Id zwierzecia:",
                                 choices = id_zwierzat_r,
                                 selected = min(id_zwierzat_r)),
                     selectInput(col_names[4], "Typ badania:",
                                 choices = c("profilaktyczne", "leczenie"),
                                 selected = "profilaktyczne"),
                     textInput(col_names[5], "Nazwa choroby:")
      )
    } 
    else if (table_name == "sponsorzy"){
      inputs <- list(textInput(col_names[1], "Nazwa firmy:"),
                     textInput(col_names[2], "Imie:"),
                     textInput(col_names[3], "Nazwisko:")
      )
    } 
    else if (table_name == "donacje"){
      id_sponsorow_sql <- "SELECT id_sponsora FROM sponsorzy;"
      id_sponsorow_r <- dbGetQuery(con, id_sponsorow_sql)
      id_zwierzat_sql <- "SELECT id_zwierzecia FROM zwierzeta;"
      id_zwierzat_r <- dbGetQuery(con, id_zwierzat_sql)
      inputs <- list(textInput(col_names[1], "Data i czas wplaty:"),
                     selectInput(col_names[2], "Id sponsora:",
                                 choices = id_sponsorow_r,
                                 selected = min(id_sponsorow_r)),
                     selectInput(col_names[3], "Id zwierzecia:",
                                 choices = id_zwierzat_r,
                                 selected = min(id_zwierzat_r)),
                     sliderInput(col_names[4], "Kwota:",
                                 min = 1, max = 20000, value = 1, step = 1)
      )
    } 
    else if (table_name == "sklep"){
      gatunki_sql <- "SELECT gatunek FROM gatunki;"
      gatunki_r <- dbGetQuery(con, gatunki_sql)
      inputs <- list(selectInput(col_names[1], "Gatunek - motyw pamiatki:",
                                 choices = gatunki_r,
                                 selected = gatunki_r[1]),
                     textInput(col_names[2], "Rodzaj pamiatki:"),
                     sliderInput(col_names[3], "Ilosc na stanie:",
                                 min = 1, max = 1000, value = 1, step = 1)
      )
    }
    tagList(inputs)
  })
  
  
  # Obsluga zapisu nowej krotki:
  observeEvent(input$save_record, {
    table_name <- input$table
    values <- sapply(colnames(load_table(table_name)), function(col) input[[col]])
    insert_record(table_name, values)
    shinyjs::disable("save_record")
    shinyjs::enable("add_record")
  })
  
  
  deleteValues <- reactiveVal(NULL)
  

  # Pobieranie danych z krotki do skasowania:
  output$delete <- renderUI({
    table_name <- input$table
    table_data <- load_table(table_name)
    col_names <- important_columns(table_name, colnames(table_data))
    inputs <- table_data[input$table_output_rows_selected, ]
    deleteValues(inputs)
  })
  
  
  # Obsluga usuwania starej krotki:
  observeEvent(input$remove_record, {
    table_name <- input$table
    values <- deleteValues()
    remove_rec(table_name, values)
  })
}


shinyApp(ui, server)

