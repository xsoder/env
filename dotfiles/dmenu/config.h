/* See LICENSE file for copyright and license details. */
/* Default settings; can be overridden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen            */
static int min_width = 500;                 /* minimum width when centered                   */
static const float menu_height_ratio = 6.0f;/* Dropdown height ratio                         */
static const int user_bh = 0;               /* Additional pixels to bar height               */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
    "Iosevka:size=18"
};

static const char *prompt = "Run ";  /* -p  option; prompt to the left of input field */

static const char *colors[SchemeLast][2] = {
    /*               fg         bg        */
    [SchemeNorm]   = { "#e4e4ef", "#181818" }, /* Normal text on dark background */
    [SchemeSel]    = { "#f4f4ff", "#444444" }, /* Selected text on medium gray  */
    [SchemeOut]    = { "#f5f5a0", "#181818" }, /* Rarely used output highlight  */
    [SchemeBorder] = { "#444444", "#181818" }, /* Accent color for borders      */
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines = 10;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 3;

