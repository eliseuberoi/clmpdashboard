### Package constants

get_NOBLE_TITLES <- function() {

    NOBLE_TITLES <- c(
        "^Lord ",
        "^Baroness ",
        "^Viscount ",
        "^Bishop ",
        "^Viscountess ",
        "^Earl ",
        "^Countess ",
        "^The Lord ",
        "^The Earl",
        "^The Viscount",
        "^The Viscountess",
        "^The Countess"
    )
}

get_MP_TITLES <- function() {

    MP_TITLES <- c(
        "^Mrs ",
        "^Ms ",
        "^Miss ",
        "^Mr ",
        "^Dr ",
        "^Sir ",
        "^Dame "
    )
}


NOBLE_TITLES <- get_NOBLE_TITLES()

MP_TITLES <- get_MP_TITLES()

MEMBERS <- get_members()

STOPWORDS <- get_STOPWORDS()
