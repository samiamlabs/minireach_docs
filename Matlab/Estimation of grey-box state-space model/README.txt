Matlab-kod framtagen under utveckling av en tillst�ndsmodell f�r minireach truck i CDIO projekt i kurs TSRT10, h�sten 2017.



F�r att ta fram modeller har system identification toolbox anv�nts. F�r att k�ra handle_data.m beh�vs inte denna toolbox utan 
endast om man vill ta fram nya modeller. F�r att l�sa bag-filer beh�vs toolboxen "Robotics System Toolbox". Denna beh�vs f�r att 
k�ra "handle_data.m".

Om man endast �nskar att unders�ka systemet r�cker det med att handle_data.m k�rs:
	1. Ha Robotics System Toolbox installerad.
	2. I b�rjan p� handle_data.m, v�lj filnamn p� den bagfil placerad i mappen "bags" som du vill unders�ka.
	3. K�r hela handle_data.m.
	4. I mappen plots/[filnamn] finns resultatet.


Modellen hanterar �nskad linj�r och rotationshastighet som insignal och ger position och rotation som utsignal.

Linj�ra modeller f�r �verf�ring fr�n �nskad linj�r hastighet till uppm�tt linj�r hastighet och f�r rotationshastighet har
utvecklats. Dessutom har en linj�r modell f�r f�rh�llande mellan absolutbeloppet av derivatan av �nskad rotationshastighet
och uppm�tt linj�r hastighet utvecklats.

Tv� modeller av olika ordning har tagits fram med System Identification toolbox med hj�lp av data i filerna:
	- hastighet2hastighet.m 
	- rotationshastighet2rotationshastighet
	- rotationshastighet2hastighet.
Modellerna finns sparade i mat-filer.

I "handle_data.m" s�tts alla linj�ra modeller samman tillsammans med dess p�verkan p� position till tv� stora tillst�ndsmodeller.
Modellerna simuleras sedan i simulinkfilen "nonlinear_truck.slx". D�refter skapas en rad plottar �ver linj�r hastighet, 
rotationshastighet, position, etc... Dessutom finns en enklare animering �ver position fr�n verkligheten och simulationen med 
modellen av h�g ordning.

Simuleringen kr�ver insignaler fr�n inspelade bagfiler. Dessa ska finns sparade i en mapp som heter bags. Denna mapp ska vara placerad i 
samma mapp som kodfilerna. Resulterande plottar sparas i en mapp som heter "plots" d�r varje bagfil ger upphov till en egen mapp.
Om ingen mapp har skapats s� skapas en n�r handle_data.m k�rs.

Alla siffror i modellerna finns presenterade i den tekniska rapport som levererades i projektet.

Fr�gor kan eventuellt besvaras via mail: danni768@student.liu.se eller daniel.nilsson4@gmail.com



