### Package constants

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
        # "^The Viscountess",
        "^The Countess"
)

MP_TITLES <- c(
        "^Mrs ",
        "^Ms ",
        "^Miss ",
        "^Mr ",
        "^Dr ",
        "^Sir ",
        "^Dame ")


MEMBERS <- get_members()

STOPWORDS <- get_STOPWORDS()
