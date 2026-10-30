# Python-oppsett for Geofag 2

To korte guider for elever i Geofag 2: hvordan de installerer Miniforge og Jupyter Lab, og hvordan de kjører driftvarsling med OpenDrift og ferske varsler fra Meteorologisk institutt. Guidene publiseres som nettsider og PDF i designprofilen **PGelisa på tur**.

| Kilde | Nettside | PDF | Innhold |
|---|---|---|---|
| `index.qmd` | `index.html` | `index.pdf` | Installere Miniforge, lage miljøet `geofag2` og åpne Jupyter Lab |
| `opendrift.qmd` | `opendrift.html` | `opendrift.pdf` | Lage miljøet `opendrift` og kjøre notatboka med ferske varsler |

Notatboka ligger i `opendrift/driftvarsling_opendrift.ipynb`, sammen med en ferdig kjørt eksempelversjon som HTML.

## Mappestruktur

```
_quarto.yml              prosjektoppsett: hvilke filer som bygges, og i hvilke formater
index.qmd, opendrift.qmd guidene
img/                     bilder i guidene
opendrift/               notatboka og eksempelkjøringen
_extensions/pgelisa/     designprofilen PGelisa på tur
```

## Bygge guidene

Du trenger [Quarto](https://quarto.org) og en LaTeX-installasjon for PDF (for eksempel TinyTeX: `quarto install tinytex`). Kjør i rotmappa:

```bash
quarto render
```

Da lages både HTML og PDF for begge guidene. HTML-filene er selvstendige: fonter, logo og bilder er bygd inn, og siden henter ingenting utenfra.

## Designprofilen

Utseendet kommer fra Quarto-utvidelsen i `_extensions/pgelisa`. Den gir to formater:

- `pgelisa-html`: nettside med tittelfelt i dypvann og merket til høyre, lys og mørk modus (følger maskinens innstilling), fargene i profilen for lenker, kode, faner og callout-bokser.
- `pgelisa-pdf`: PDF med KOMA-Script og xelatex, logoen øverst på forsiden, samme farger og fonter.

| Fil | Hva den gjør |
|---|---|
| `_extension.yml` | Definerer formatene og standardvalgene (språk, innholdsfortegnelse, datoformat, kodefarger) |
| `pgelisa.scss` | Farger, fonter og regler for nettsider i lys modus |
| `pgelisa-mork.scss` | Fargene i mørk modus |
| `pgelisa-pdf.tex` | Farger, fonter, logo og callout-farger for PDF |
| `pgelisa.theme`, `pgelisa-mork.theme` | Kodefarger i lys og mørk modus |
| `fonts/` | Atkinson Hyperlegible (brødtekst) og Bricolage Grotesque (titler), woff2 til nett og ttf til PDF |
| `logo/` | Logoen i SVG, og som PDF til LaTeX |

Fontene har SIL Open Font License.

### Bruke profilen i et annet Quarto-prosjekt

Kopier mappa `_extensions/pgelisa` inn i det nye prosjektet og skriv i `_quarto.yml` eller i toppen av dokumentet:

```yaml
format:
  pgelisa-html: default
  pgelisa-pdf: default
```

Stiene til fonter og logo forutsetter at dokumentene ligger i prosjektets rotmappe, slik de gjør her.

### Endre farger

Fargene er rollene fra designsystemet PGelisa på tur (for eksempel `$merke`, `$dyp`, `$status-advarsel`). Endrer du en farge, må den endres både i `pgelisa.scss`, `pgelisa-mork.scss` og `pgelisa-pdf.tex`.

---

OpenDrift er utviklet av Meteorologisk institutt og er fri programvare: <https://opendrift.github.io>.
