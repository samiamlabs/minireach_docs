Matlab-kod framtagen under utveckling av en tillståndsmodell för minireach truck i CDIO projekt i kurs TSRT10, hösten 2017.



För att ta fram modeller har system identification toolbox använts. För att köra handle_data.m behövs inte denna toolbox utan 
endast om man vill ta fram nya modeller. För att läsa bag-filer behövs toolboxen "Robotics System Toolbox". Denna behövs för att 
köra "handle_data.m".

Om man endast önskar att undersöka systemet räcker det med att handle_data.m körs:
	1. Ha Robotics System Toolbox installerad.
	2. I början på handle_data.m, välj filnamn på den bagfil placerad i mappen "bags" som du vill undersöka.
	3. Kör hela handle_data.m.
	4. I mappen plots/[filnamn] finns resultatet.


Modellen hanterar önskad linjär och rotationshastighet som insignal och ger position och rotation som utsignal.

Linjära modeller för överföring från önskad linjär hastighet till uppmätt linjär hastighet och för rotationshastighet har
utvecklats. Dessutom har en linjär modell för förhållande mellan absolutbeloppet av derivatan av önskad rotationshastighet
och uppmätt linjär hastighet utvecklats.

Två modeller av olika ordning har tagits fram med System Identification toolbox med hjälp av data i filerna:
	- hastighet2hastighet.m 
	- rotationshastighet2rotationshastighet
	- rotationshastighet2hastighet.
Modellerna finns sparade i mat-filer.

I "handle_data.m" sätts alla linjära modeller samman tillsammans med dess påverkan på position till två stora tillståndsmodeller.
Modellerna simuleras sedan i simulinkfilen "nonlinear_truck.slx". Därefter skapas en rad plottar över linjär hastighet, 
rotationshastighet, position, etc... Dessutom finns en enklare animering över position från verkligheten och simulationen med 
modellen av hög ordning.

Simuleringen kräver insignaler från inspelade bagfiler. Dessa ska finns sparade i en mapp som heter bags. Denna mapp ska vara placerad i 
samma mapp som kodfilerna. Resulterande plottar sparas i en mapp som heter "plots" där varje bagfil ger upphov till en egen mapp.
Om ingen mapp har skapats så skapas en när handle_data.m körs.

Alla siffror i modellerna finns presenterade i den tekniska rapport som levererades i projektet.

Frågor kan eventuellt besvaras via mail: danni768@student.liu.se eller daniel.nilsson4@gmail.com



