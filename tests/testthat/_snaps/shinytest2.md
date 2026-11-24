# {shinytest2} Query 3: CSV and XLSX downloads contain the data of the address

    "Liegenschaftenhandel_nach_Bauzonenordnung_und_Quartier_Wollishofen.csv"

---

    Code
      sheet1[, 1:4]
    Output
                                              X1
      1                 Napfgasse 6, 8022 Zürich
      2                    Telefon 044 412 08 00
      3 Internet: www.stadt-zuerich.ch/statistik
      4             E-Mail: statistik@zuerich.ch
      5                                     <NA>
      6                                   Inhalt
      7                                      T_1
                                                                         X2
      1                                                                <NA>
      2                                                                <NA>
      3                                                                <NA>
      4                                                                <NA>
      5                                                                <NA>
      6                                                                <NA>
      7 Grundstückspreise (Median) für Ihre Adresseingabe: Verenastrasse 16
                 X3         X4
      1        <NA>       <NA>
      2        <NA>       <NA>
      3        <NA>       <NA>
      4        <NA>       <NA>
      5 Erstellt am 24.11.2026
      6        <NA>       <NA>
      7        <NA>       <NA>

---

    Code
      sheet2
    Output
                              X1
      1         Abfragetool LIMA
      2      Näherung Bodenpreis
      3                      Typ
      4                 QuarLang
      5                      BZO
      6                     Jahr
      7       FrQmBodenGanzeLieg
      8            FrQmBodenStwE
      9          FrQmBodenAlleHA
      10 FrQmBodenNettoGanzeLieg
      11      FrQmBodenNettoStwE
      12    FrQmBodenNettoAlleHA
      13          FrQmWohnflStwE
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            X2
      1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Die Angaben des Abfragetools LIMA (LIegenschaftenMArkt) auf der Website von Statistik Stadt Zürich basieren auf Handänderungsanzeigen der Grundbuchämter über Verkäufe von bebauten Grundstücken auf dem Gebiet der Stadt Zürich.
      2  In der Stadt Zürich ist praktisch kein unbebautes Bauland mehr vorhanden. Dementsprechend kann kein Bodenpreis ausgewiesen werden. Am nächsten kommen dem Konzept der Bodenpreise die Werte in der Variable FrQmBodenNettoGanzeLieg: der Verkaufspreis pro Quadratmeter Grundstücksfläche abzüglich des Gebäudeversicherungswerts für ganze Liegenschaften (also ohne Miteinbezug von Stockwerkeigentums-Transaktionen). Der Abzug des Gebäudeversicherungswertes vom Kaufpreis hat den Zweck, den theoretischen Landwert zu ermitteln, als Residualwert des Gesamtpreises minus des Gebäudewertes. Jedoch ist zu bedenken, dass der Gebäudeversicherungswert den Kosten für einen Wiederaufbau entspricht, also dem Neuwert eines Gebäudes und nicht dem durch die Altersentwertung reduzierten Zeitwert. Da der Neuwert höher ist als der Zeitwert und somit der Abzug für den Gebäudewert eher zu hoch ist, dürften die ausgewiesenen Werte tendenziell unter dem effektiven Bodenpreis liegen. Sie bilden somit nur einen Näherungswert für den Bodenpreis und sind grundsätzlich mit Vorsicht zu interpretieren.
      3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Typ der Information: Preis oder Zahl
      4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Stadtquartier
      5                                                                                                      Mit der Revision der Bau- und Zonenordnung (BZO) 2016 wurde die BZO 1999 ausser Kraft gesetzt. In den Handänderungsdaten beziehen sich die Preise ab 2019 auf die BZO 2016. Die Preise bis 2018 beziehen sich auf die BZO 1999. Während die verschiedenen Mischzonen (Kernzonen, Quartiererhaltungszonen, Zentrumszonen) in der BZO 2016 noch weitgehend mit der BZO 1999 vergleichbar sind, wechselten die Bezeichnungen der Wohnzonen grundlegend. In der Revision wurde bestimmt, dass in den Wohnzonen zur Kompensation des früher zulässigen Untergeschosses ein zusätzliches Geschoss erlaubt ist. Frühere W3-Zonen wurden so neu zu W4-Zonen, W4 zu W5, W5 zu W6. Das bedeutet, dass zum Beispiel die W4-Zone heute Gebiete umfasst, die bis 2018 als W3 bezeichnet wurden, aber baurechtlich vergleichbar sind. Oder umgekehrt: Eine W3 vor 2018 ist nicht mit einer W3 nach 2018 zu vergleichen, sondern mit einer W4. Die Darstellung der Abfrageresultate in Abfrage 1 nimmt Bezug auf diesen Wechsel.
      6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Jahr der Transaktion
      7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Preis pro Quadratmeter Grundstücksfläche, nur ganze Liegenschaften (ohne Miteigentum und Stockwerkeigentum)
      8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Preis pro Quadratmeter Grundstücksfläche, Stockwerkeigentum
      9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Preis pro Quadratmeter Grundstücksfläche, alle Verkäufe (ganze Liegenschaften, Stockwerkeigentum, Miteigentumsanteile)
      10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Preis pro Quadratmeter Grundstücksfläche abzüglich Versicherungswert, nur ganze Liegenschaften ohne Miteigentum und Stockwerkeigentum (Näherungswert für Bodenpreis, vgl. Zusatzinformationen)
      11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Preis pro Quadratmeter Grundstücksfläche abzüglich Versicherungswert , Stockwerkeigentum
      12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Preis pro Quadratmeter Grundstücksfläche abzüglich Versicherungswert , alle Verkäufe (ganze Liegenschaften, Stockwerkeigentum, Miteigentumsanteile)
      13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Preis pro Quadratmeter Wohnungsfläche bei Stockwerkeigentumskäufen

---

    Code
      sheet3
    Output
                                                          X1          X2   X3
      1                                                  T_1        <NA> <NA>
      2  Grundstückspreise (Median) für Ihre Adresseingabe:         <NA> <NA>
      3                                     Verenastrasse 16        <NA> <NA>
      4                                                             <NA> <NA>
      5                  Quelle: Statistik Stadt Zürich, GWZ        <NA> <NA>
      6                                                  Typ    QuarLang Jahr
      7                                                Preis Wollishofen 2025
      8                                                Preis Wollishofen 2024
      9                                                Preis Wollishofen 2023
      10                                               Preis Wollishofen 2022
      11                                               Preis Wollishofen 2021
      12                                               Preis Wollishofen 2020
      13                                               Preis Wollishofen 2019
      14                                               Preis Wollishofen 2018
      15                                               Preis Wollishofen 2017
      16                                               Preis Wollishofen 2016
      17                                               Preis Wollishofen 2015
      18                                               Preis Wollishofen 2014
      19                                               Preis Wollishofen 2013
      20                                               Preis Wollishofen 2012
      21                                               Preis Wollishofen 2011
      22                                               Preis Wollishofen 2010
      23                                               Preis Wollishofen 2009
      24                                               Preis Wollishofen 2008
      25                                                Zahl Wollishofen 2025
      26                                                Zahl Wollishofen 2024
      27                                                Zahl Wollishofen 2023
      28                                                Zahl Wollishofen 2022
      29                                                Zahl Wollishofen 2021
      30                                                Zahl Wollishofen 2020
      31                                                Zahl Wollishofen 2019
      32                                                Zahl Wollishofen 2018
      33                                                Zahl Wollishofen 2017
      34                                                Zahl Wollishofen 2016
      35                                                Zahl Wollishofen 2015
      36                                                Zahl Wollishofen 2014
      37                                                Zahl Wollishofen 2013
      38                                                Zahl Wollishofen 2012
      39                                                Zahl Wollishofen 2011
      40                                                Zahl Wollishofen 2010
      41                                                Zahl Wollishofen 2009
      42                                                Zahl Wollishofen 2008
                         X4            X5              X6                      X7
      1                <NA>          <NA>            <NA>                    <NA>
      2                <NA>          <NA>            <NA>                    <NA>
      3                <NA>          <NA>            <NA>                    <NA>
      4                <NA>          <NA>            <NA>                    <NA>
      5                <NA>          <NA>            <NA>                    <NA>
      6  FrQmBodenGanzeLieg FrQmBodenStwE FrQmBodenAlleHA FrQmBodenNettoGanzeLieg
      7                8850         22465            8955                    5970
      8                5956         23133           22671                    3566
      9                9254         14515            9283                    5931
      10              10088         13638           12914                    7810
      11               8889         17372           17268                    5830
      12               4076         13312            7463                    2449
      13               5013         15890           10497                    2562
      14               5916         10112            6899                    3520
      15               4794         14910            5278                    3201
      16               4811         13339            6630                    3137
      17               4600          9725            5863                    2170
      18               2986         11248            3103                    1708
      19               3295          9111            3802                    2377
      20               3878          8869            8652                    1996
      21               3987         11234            4789                    2252
      22               3004          4420            4287                    1322
      23               3620          9605            8678                    1623
      24               2899         11791            5176                    1707
      25                  7           1–3               8                       7
      26                1–3            18              21                     1–3
      27                1–3           1–3             5–7                     1–3
      28                1–3           1–3               5                     1–3
      29                1–3         15–17              22                     1–3
      30                1–3           1–3               6                     1–3
      31                3–5           5–7               9                     3–5
      32                 10             7              18                      10
      33                7–9             4              11                     7–9
      34                  9             6              15                       9
      35                5–9           6–8              16                     5–9
      36                  7           1–3               8                       6
      37                5–7           1–5              10                     4–6
      38                3–5            18              23                     3–5
      39                  9           1–3              12                       9
      40                  6            13              19                       6
      41                  8            13              22                       8
      42                1–3           1–3             2–4                     1–3
                         X8                   X9
      1                <NA>                 <NA>
      2                <NA>                 <NA>
      3                <NA>                 <NA>
      4                <NA>                 <NA>
      5                <NA>                 <NA>
      6  FrQmBodenNettoStwE FrQmBodenNettoAlleHA
      7               15863                 6103
      8               14928                14462
      9                9752                 6777
      10               8200                 7661
      11              11616                11517
      12               5884                 4249
      13              11260                 5153
      14               5906                 4373
      15               9025                 3333
      16               7271                 3624
      17               6280                 3656
      18               6010                 1780
      19               6245                 2596
      20               5471                 4941
      21               6833                 2520
      22               1921                 1322
      23               4204                 2723
      24               7623                 3025
      25                1–3                    8
      26                 17                   20
      27                1–3                  5–7
      28                1–3                    5
      29              15–17                   22
      30                1–3                    6
      31                5–7                    9
      32                  7                   18
      33                  4                   11
      34                6–8                   15
      35                  6                   15
      36                1–3                    7
      37                1–4                 8-10
      38              14–18                   23
      39                1–3                   12
      40                6-8                   14
      41                 13                   21
      42                1–3                  1–3

