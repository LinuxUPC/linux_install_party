# Passos previs abans de la install party

Per anar més ràpids el dia de la install party, necessitem que porteu el material ja preparat.

> [!IMPORTANT]
> Aquest document també té algunes explicacions tècniques amb més detall, per si teniu curiositat.
> Si no us voleu complicar la vida, les podeu ignorar fàcilment.

> [!NOTE]
> **Portàtils Apple:** instal·lar Linux nativament pot ser més complicat, especialment en els Mac amb Apple Silicon (M1, M2, M3, etc.).
> Si teniu un Mac i no esteu segurs de si és compatible, consulteu-nos abans de la install party.
>
> Si no teniu cap altre ordinador, també podem instal·lar Linux en una màquina virtual. En aquest cas només necessiteu fer el pas 2.
>
> La resta d'instruccions assumeixen que el canvi es fa des de Windows.

## Checklist

Abans de venir, assegureu-vos de tenir:

- 💾 Una memòria USB de **8 GB o més**
- 💿 La ISO de Linux descarregada
- 🔥 La ISO flashejada a la memòria USB
- 💾 Una còpia de seguretat dels vostres fitxers importants
- 🔌 El carregador del portàtil
- 🔑 La contrasenya del vostre compte de Microsoft

## 1 - Memòria USB Flash amb 8 GB o més

Per instal·lar Linux necessitem una memòria USB.

Normalment no necessitareu més de 8 GB, però si voleu fer servir l'USB per a altres coses més endavant, potser us convé que tingui més capacitat.

> [!WARNING]
> Quan preparem l'USB per instal·lar Linux, **s'esborrarà tot el seu contingut**.
> Assegureu-vos que no hi tingueu fitxers importants.


## 2 - Descarregar la ISO de la distribució

Hi ha moltes distribucions (*distros*) de Linux diferents. Si mai heu utilitzat Linux, és difícil saber quina és millor per a vosaltres.
Nosaltres us recomanem una de les següents:
- [Ubuntu](https://ubuntu.com/download/desktop): és una de les distribucions més utilitzades i tradicionalment una de les més recomanades per a principiants.
- [Debian](https://www.debian.org/): és una distribució molt estable, però les versions més noves d'alguns programes no sempre estan disponibles fàcilment.
- [Linux Mint](https://www.linuxmint.com/download.php): és especialment popular entre usuaris que venen de Windows.

També podeu buscar altres opcions per Internet.

En qualsevol cas, és molt habitual canviar de distro un cop tens més experiència amb Linux. **No cal que seleccioneu la distro perfecta a la primera!**

<details>
<summary>🔧 Detalls tècnics: què és realment una distro?</summary>

Normalment, als principiants se'ls diu que les distribucions són "versions" de Linux. Això no és del tot exacte.

Primer hem d'entendre que Linux, pròpiament dit, no és un sistema operatiu complet. Linux és un **kernel**: la part del sistema que s'encarrega de comunicar-se amb el maquinari i gestionar recursos com la memòria, els processos i els dispositius.

Una distribució de Linux és un conjunt de programes que algú ha agrupat al voltant del kernel per facilitar-nos la vida.

Normalment una distro inclou:
- El kernel de Linux
- Eines bàsiques del sistema
- Un gestor de paquets
- Sistemes i serveis necessaris per fer funcionar el sistema

I moltes també inclouen:
- Un *Desktop Environment* (DE), com Cinnamon, XFCE, MATE, GNOME o KDE Plasma
- Aplicacions útils, com ara navegadors, editors de fitxers, calculadora, etc.

### Què és un Desktop Environment?

El *Desktop Environment* (DE), o **entorn d'escriptori**, és el conjunt de programes que proporciona la interfície gràfica del sistema.

Inclou coses com:
- L'explorador de fitxers
- El menú d'aplicacions
- La configuració de Wi-Fi
- La pantalla d'inici de sessió
- El gestor de finestres
- Altres elements de la interfície gràfica

Per tant, quan us agrada (o no us agrada) l'aspecte visual d'una distro, moltes vegades el que realment esteu veient és el seu **Desktop Environment**.

I el podeu canviar: podeu instal·lar un altre DE en una mateixa distro.

De fet, molts usuaris més avançats instal·len una distro minimalista sense entorn d'escriptori i després instal·len les diferents aplicacions i components al seu gust.
L'inconvenient és que heu d'estar vosaltres mateixos pendents que tot funcioni i requereix més feina per deixar el sistema preparat per al dia a dia.
</details>

## 3 - Flashejar la ISO a la memòria USB

Ara hem de preparar la memòria USB perquè l'ordinador pugui iniciar l'instal·lador de Linux des d'ella.

Podeu seguir [aquest vídeo de YouTube](https://www.youtube.com/watch?v=qedjN2AA3gU), que explica com flashejar una ISO a una memòria USB amb **Rufus**.

> [!WARNING]
> Assegureu-vos de seleccionar **la memòria USB correcta**. Flashejar una ISO normalment esborra tot el contingut de la memòria seleccionada.

Quan acabeu, hauríeu de tenir una memòria USB preparada per instal·lar Linux.

<details>
<summary>🔧 Detalls tècnics: què vol dir "flashejar" una ISO?</summary>

Una ISO és un fitxer que conté una còpia completa de l'estructura d'un disc, en aquest cas el disc d'instal·lació de Linux.
No n'hi ha prou amb copiar el fitxer `.iso` a l'USB com si fos un document normal.

Quan "flashem" una ISO, escrivim el seu contingut a la memòria USB directament bit a bit de manera que l'ordinador pugui iniciar-se directament des d'ella.
Això crea un **USB d'arrencada** (*bootable USB*).
</details>

## 4 - Desactivar BitLocker

Heu de desactivar **BitLocker** abans de venir.

BitLocker és el sistema de xifratge de disc de Windows. El podem tornar a activar després de la install party si continueu utilitzant Windows.

Per desactivar-lo:
1. Obriu el menú **Inici** de Windows.
2. Busqueu **BitLocker**.
3. Obriu **Gestiona BitLocker**.
4. Seleccioneu **Desactiva BitLocker** a la unitat corresponent.
5. Espereu que Windows acabi de desxifrar la unitat.

> [!NOTE]
> El procés de desxifrat pot trigar una estona, simplement assegureu-vos que el procés ha començat i deixeu el portàtil connectat al carregador (podeu seguir fent servir l'ordinador).

Si no trobeu aquesta opció, no us preocupeu: consulteu-nos abans de la install party per email o per les nostres xarxes socials. 

## 5 - Fer una còpia de seguretat

**Feu una còpia de seguretat de tots els fitxers importants abans de venir.**
Si instal·larem Linux esborrant Windows, podem acabar esborrant completament el disc del portàtil. 
Nosaltres intentarem instalar Linux fent un **Dual Boot**, aixo permet tenir tant Linux com Windows en un mateix ordinador pero per si de cas heu de tenir la copia de seguretat feta. 

Com a mínim, assegureu-vos de tenir una còpia de:
- Documents
- Fotografies i vídeos
- Fitxers de l'escriptori
- Fitxers de la carpeta de Descàrregues
- Projectes o treballs
- Qualsevol altre fitxer que no vulgueu perdre

Podeu fer la còpia a un disc extern, una memòria USB o un servei d'emmagatzematge al núvol.

> [!IMPORTANT]
> No considereu que un fitxer està protegit només perquè està al vostre ordinador.
> **Comproveu que la còpia de seguretat funciona i que podeu accedir als fitxers abans de venir.**


# El dia de la install party

Porteu:
- 💻 El vostre portàtil
- 🔌 **El carregador**
- 💾 La memòria USB amb Linux preparada
- 🔑 La contrasenya del vostre compte de Microsoft
- 💾 Una còpia de seguretat dels vostres fitxers importants

> [!IMPORTANT]
> Si teniu algun dubte sobre la compatibilitat del vostre ordinador o sobre algun dels passos anteriors, **no intenteu solucionar-lo a cegues**. Pregunteu-nos abans de la install party i ho revisem.
