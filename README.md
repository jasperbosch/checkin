# checkin
Tool voor het bijhouden van verlofdagen en thuiswerkdagen icm sprints.

## Installatie
Kopieer de inhoud van deze folder naar de www-folder van bijvoorbeeld wamp.
Voer het sql-script uit dat in de scripts-folder staat. Dit kan je doen door in phpMyAdmin het sql-script uit te voeren, maar je kunt ook /scripts/dbsetup.php uitvoeren vanuit je browser (Zorg er dan wel voor dat je eerst de Configuratie goed heb staan).

## Configuratie
In de het bestand db-settings in de server/models-folder en de admin/models-folder moet de configuratie van de database worden opgenomen.

## Admin
urlnaar admingedeelte: http(s)://server:port/checkin/admin
userid: admin
password: adminadmin

## Opvoeren gebruikers:
In het admingedeelte -> Register (email en securitycode zijn niet nodig)
