#' Filtrer les anomalies de trajet
#'
#' @param trajet Un data.frame contenant les données de comptage.
#' @return Un data.frame sans les lignes contenant des anomalies.
#' @export
#' @importFrom dplyr filter
filtre_anomalie <- function(trajet){
  trajet |>
    dplyr::filter(is.na(`Probabilité de présence d'anomalies`))
}

#' Compter le nombre total de trajets
#'
#' @param trajet Un data.frame contenant une colonne 'Total'.
#' @return La somme de la colonne Total.
#' @export
#' @importFrom dplyr pull
compter_nombre_trajets <- function(trajet){
  trajet |>
    dplyr::pull(Total) |>
    sum(na.rm = TRUE)
}

#' Compter le nombre de boucles distinctes
#'
#' @param trajet Un data.frame contenant une colonne 'Numéro de boucle'.
#' @return Le nombre de boucles uniques.
#' @export
#' @importFrom dplyr pull n_distinct
compter_nombre_boucle <- function(trajet){
  trajet |>
    dplyr::pull(`Numéro de boucle`) |>
    dplyr::n_distinct()
}

#' Trouver la boucle avec le plus grand nombre de trajet
#'
#' @param trajet Un data.frame.
#' @return Un data.frame avec la ligne ayant le maximum de passages.
#' @export
#' @importFrom dplyr slice_max select
trouver_trajet_max <- function(trajet){
  trajet |>
    dplyr::slice_max(Total) |>
    dplyr::select(`Boucle de comptage`, Jour, Total)
}

#' Calculer la distribution des trajets par jour de la semaine
#'
#' @param trajet Un data.frame.
#' @return Un data.frame groupé par jour avec le total des trajets.
#' @export
#' @importFrom dplyr count
calcul_distribution_semaine <- function(trajet){
  trajet |>
    dplyr::count(`Jour de la semaine`, wt = Total, sort = TRUE, name = "trajets")
}

#' Afficher le graphique de la distribution hebdomadaire
#'
#' @param trajet Un data.frame.
#' @return Un objet ggplot représentant la distribution.
#' @export
#' @import ggplot2
#' @importFrom forcats fct_recode
#' @importFrom dplyr mutate
plot_distribution_semaine <- function(trajet) {
  trajet_weekday <- trajet |>
    filtre_anomalie() |>
    calcul_distribution_semaine() |>
    dplyr::mutate(
      jour = forcats::fct_recode(
        factor(`Jour de la semaine`),
        "lundi" = "1",
        "mardi" = "2",
        "mercredi" = "3",
        "jeudi" = "4",
        "vendredi" = "5",
        "samedi" = "6",
        "dimanche" = "7"
      )
    )

  ggplot2::ggplot(trajet_weekday) +
    ggplot2::aes(x = jour, y = trajets) +
    ggplot2::geom_col()
}

#' Filtrer les trajets par boucle
#'
#' @param trajet Un data.frame de données (ex: df_velo).
#' @param boucle Un vecteur de numéros de boucles (ex: c("880", "881"))[cite: 41, 42].
#'
#' @return Le data.frame filtré[cite: 41].
#' @export
filtrer_trajet <- function(trajet, boucle) {
  if (is.null(boucle)) {
    return(trajet) # Utile pour la question 14 plus tard [cite: 51]
  }

  trajet |>
    dplyr::filter(`Numéro de boucle` %in% boucle)
}
