test_that("filtre_anomalie supprime les lignes problématiques", {
  df_test <- data.frame(
    Total = c(10, 20),
    `Probabilité de présence d'anomalies` = c(NA, 0.9),
    check.names = FALSE
  )
  resultat <- filtre_anomalie(df_test)
  expect_equal(nrow(resultat), 1)
})

test_that("compter_nombre_trajets calcule la somme correcte avec NA", {
  # On crée un jeu de données avec une valeur manquante
  df_test <- data.frame(
    Total = c(10, 20, NA, 30)
  )

  # La somme doit être 60 (10+20+30), car le NA est ignoré
  expect_equal(compter_nombre_trajets(df_test), 60)
})

test_that("compter_nombre_boucle compte correctement les identifiants uniques", {
  df_test <- data.frame(`Numéro de boucle` = c("A", "A", "B"), check.names = FALSE)
  expect_equal(compter_nombre_boucle(df_test), 2)
})

test_that("trouver_trajet_max identifie le bon maximum", {
  df_test <- data.frame(
    Total = c(10, 100, 50),
    `Boucle de comptage` = c("Petit", "Grand", "Moyen"),
    Jour = as.Date(c("2025-01-01", "2025-01-02", "2025-01-03")),
    check.names = FALSE
  )
  resultat <- trouver_trajet_max(df_test)
  expect_equal(resultat$Total, 100)
})

test_that("calcul_distribution_semaine renvoie un tableau groupé", {
  df_test <- data.frame(
    Total = c(10, 20, 30),
    `Jour de la semaine` = c("Lundi", "Lundi", "Mardi"),
    check.names = FALSE
  )
  resultat <- calcul_distribution_semaine(df_test)
  # On vérifie qu'on a bien deux lignes (Lundi et Mardi)
  expect_equal(nrow(resultat), 2)
})



test_that("compter_nombre_trajets calcule la bonne somme", {
  # créatione un petit tableau de test
  donnees_test <- data.frame(Total = c(10, 20, 30))

  # verif que la fonction renvoie bien 60
  expect_equal(compter_nombre_trajets(donnees_test), 60)
})

test_that("plot_distribution_semaine renvoie un objet ggplot", {
  # On crée un jeu de données complet pour que les fonctions internes ne plantent pas
  df_test <- data.frame(
    Total = c(10, 20),
    `Jour de la semaine` = c("Lundi", "Mardi"),
    # On ajoute la colonne manquante pour filtre_anomalie
    `Probabilité de présence d'anomalies` = c(NA, NA),
    check.names = FALSE
  )

  # On teste la fonction
  p <- plot_distribution_semaine(df_test)

  # On vérifie que c'est bien un graphique
  expect_s3_class(p, "ggplot")
})

test_that("filtrer_trajet selectionne les bonnes boucles", {
  donnees_test <- data.frame(
    `Numéro de boucle` = c("1", "2", "3"),
    Total = c(10, 10, 10),
    check.names = FALSE
  )

  resultat <- filtrer_trajet(donnees_test, boucle = c("1", "2"))

  # verif qu'il ne reste que 2 lignes
  expect_equal(nrow(resultat), 2)
  # verif que la boucle "3" a disparu
  expect_false("3" %in% resultat$`Numéro de boucle`)
})

test_that("filtrer_trajet renvoie un jeu de données non filtré si le paramètre boucle est NULL", {
  # Création d'un petit jeu de données de test
  df_test <- data.frame(
    `Numéro de boucle` = c("101", "102", "103"),
    Total = c(10, 20, 30),
    check.names = FALSE
  )

  # Appel de la fonction avec boucle = NULL
  resultat <- filtrer_trajet(trajet = df_test, boucle = NULL)

  # On vérifie que le nombre de lignes est identique au départ (pas de filtre)
  expect_equal(nrow(resultat), 3)
  expect_equal(resultat, df_test)
})
