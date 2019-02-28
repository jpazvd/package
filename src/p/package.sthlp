{smcl}
{* *! version 1.0.3 20 Feb 2019}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install CCC" "ssc install CCC"}{...}
{vieweralsosee "Help CCC (if installed)" "help CCC"}{...}
{viewerjumpto "Syntax" "package##syntax"}{...}
{viewerjumpto "Description" "package##description"}{...}
{viewerjumpto "Options" "package##options"}{...}
{viewerjumpto "Remarks" "package##remarks"}{...}
{viewerjumpto "Examples" "package##examples"}{...}
{title:Title}
{phang}
{bf:package} {hline 2} Stata module to generate a Github dissemination package

{marker syntax}{...}
{title:Syntax}

{p 4 17 2} Syntax 1:{p_end}
{p 8 17 2}
{cmdab:package} pkgname [{cmd:,} {it:options}]

{p 4 17 2} Syntax 2:{p_end}
{p 8 17 2}
{cmdab:package} {cmd:, name(}{it:pkgname}{cmd:)} [{it:options}]

{pstd}where {it:pkgname} is the name of the package.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt name(string)}} name of the package following syntax 2.{p_end}
{synopt:{opt path(string)}} directory path of package{p_end}

{syntab:General parameters (when specified, this optional paramameters are used by README, PKG, TOC and HELP fiels)}
{synopt:{opt title(string)}} title of the package. Small description{p_end}
{synopt:{opt author(string)}} name of author/s. Use comma to separate multiple authors.{p_end}
{synopt:{opt email(string)}} email of author/s. Use comma to separate multiple emails.{p_end}
{synopt:{opt institution(string)}} institution of author or package dependency. Use comma to separate multiple institutions.{p_end}
{synopt:{opt web(string)}} website address of author or/and institution. Use comma to separte multiple web sites.{p_end}
{synopt:{opt github(string)}} {p_end}
{synopt:{opt twitter(string)}} {p_end}
{synopt:{opt linkdn(string)}} {p_end}
{synopt:{opt license(string)}} license of package. Default is MIT{p_end}

{syntab:readme file}
{synopt:{opt readme(string)}} name of readme file .md{p_end}
{synopt:{opt replacereadme}} replace existing readme file{p_end}
{synopt:{opt description(string)}} long description of package{p_end}
{synopt:{opt note(string)}} additional notes{p_end}
{synopt:{opt keyword(string)}} keywords to identify package. Use comma to separate multiple keywords.{p_end}
{synopt:{opt handle(string)}} handle of package{p_end}

{syntab:pkg file}
{synopt:{opt pkg}} crate .pkg file{p_end}
{synopt:{opt replacepkg}} replace pkg file{p_end}
{synopt:{opt appendpkg}} append pkg file{p_end}
{synopt:{opt prefix(string)}} specify the name of the subdirectory in which the Stata ado files are stored.{p_end}

{syntab:toc file}
{synopt:{opt toc}} create stata.toc file{p_end}
{synopt:{opt replacetoc}} replace stata.toc file{p_end}
{synopt:{opt appendtoc	}} append to stata.toc file{p_end}

{syntab:help file}
{synopt:{opt helpfile}} create help file {ul:template}{p_end}
{synopt:{opt replacehelp}} replace existing help file{p_end}

{syntab:Seldom used}
{synopt:{opt quietly}} quietly execution{p_end}
{synopt:{opt version(numlist)}} .pkg and stata.toc files version. Default is 
3 to conform to new pkg and toc file {help usersite##remarks8:style}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{cmd:package} Automatically generate PKG, TOC, README, and HELP files for Git 
and Github dissemination of Stata user written ADO.

{marker options}{...}
{title:Options} {err: section in progress}
{dlgtab:Main}
{phang}
{opt option1(string)}

{phang}
{opt option2(numlist)}

{phang}
{opt option3(varname)}

{dlgtab:readme file}

{dlgtab:pkg file}

{dlgtab:toc file}

{dlgtab:help file}

{dlgtab:seldom used}

{marker examples}{...}
{title:Examples}

{phang} Create files for {cmd:packake}

{p 4 6 2}. package package, path("c:\Users\ffff\myados") /// {p_end}
{p 8 10 2} readme(readme) replacereadme title(Stata module to notify users the end of routines) /// {p_end} 
{p 8 10 2} description(Automatically generate PKG, TOC and README files for Git and Github dissemination of Stata user written ADOs.) /// {p_end}
{p 8 10 2} author(Joao Pedro Azevedo) /// {p_end}
{p 8 10 2} email(jazevedo@worldbank.org) ///  {p_end}
{p 8 10 2} institution(The World Bank) /// {p_end}
{p 8 10 2} pkg toc helpfile{p_end}



{p 4 6 2}. package package, path("c:\Users\ffff\myados") /// {p_end}
{p 8 10 2} readme(readme) replacereadme title(Stata module to notify users the end of routines) /// {p_end} 
{p 8 10 2} description(Automatically generate PKG, TOC and README files for Git and Github dissemination of Stata user written ADOs.) /// {p_end}
{p 8 10 2} author(Joao Pedro Azevedo, R.Andres Castaneda) /// {p_end}
{p 8 10 2} email(jazevedo@worldbank.org, acastanedaa@worldbank.org) ///  {p_end}
{p 8 10 2} institution(The World Bank, The World Bank) /// {p_end}
{p 8 10 2} web("http://www.worldbank.org/en/about/people/j/joao-pedro-azevedo", "https://github.com/randrescastaneda")  /// {p_end}
{p 8 10 2} pkg toc helpfile{p_end}

Please also see {help tknz} 

{title:Author}
{p 4 4 4}Joao Pedro Azevedo, The World Bank{p_end}
{p 6 6 4}Email: {browse "jazevedo@worldbank.org":  jazevedo@worldbank.org}{p_end}
{p 6 6 4}GitHub:{browse "https://github.com/jpazvd": jpazvd}{p_end}

{title:contributor}
{p 4 4 4}R.Andres Castaneda, The World Bank{p_end}
{p 6 6 4}Email: {browse "acastanedaa@worldbank.org":  acastanedaa@worldbank.org}{p_end}
{p 6 6 4}GitHub:{browse "https://github.com/randrescastaneda": randrescastaneda }{p_end}

