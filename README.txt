	***************************************
        *               README                  *
        *                                       *
        *       Nume proiect: Tema 2 IOCLA      *
        *       Autor: Diana Cretu              *
        *       Grupa: 322 CC                   *
        *       Deadline: Joi, 07.12.2017     	*
        *                                       *
        *                                       *
        ***************************************

1. Ierarhia proiectului

	Codul sursa este structurat in fisierul tema2.asm.


2. Descrierea aplicatiei

	Programul scris in limbaj de asamblare efectueaza
decodarea unui sir codificat printr-o metoda specificata.


3. Implementare
	
	Sirurile ce trebuie decodificate se afla in ecx, 
iar pentru a fi separate se foloseste functia extragere_siruri.

	TASK 1
	Cu ajutorul functiei extragere_siruri, exatragem sirul si 
cheia. Se foloseste functia xor_strings ce realizeaza operatia de
xor intre cuvant si cheie, cuvantul fiind suprascris cu cel decodificat.

	TASK 2
	Se utilizeaza functia rolling_xor pentru decodarea stringului
primit ca argument. Se porneste de la finalul sirului, iar parcurgerea
se opreste cand s-a ajuns la terminatorul sirului precedent. Se face xor
intre octeti, primul ramanand nemodificat.

	TASK 3
	Se utilizeaza functia xor_hex_strings care apeleaza functia 
convert_hex pentru a converti sirului de hexazecimal in decimal. Se 
iau cate 2 caractere ce se convertesc intr-un numar in decimal, iar
noul numar este pus intr-un nou sir. Este apelata din nou functia de 
la taskul 1 pentru a realiza decriptarea celor doua siruri.

	TASK 4
	Se utilizeaza de functia base32decode ce apeleaza functia binary
ce scade din codul ASCII diferenta pentru a ajunge la codul din baza 32.

	Task 5
	Este folosita functia bruteforce_singlebyte_xor ce incearca
toate caracterele din tabelul ASCII pentru a gasi cheia. Aceasta este
gasita in momentul in care se face xor cu fiecare octet (operatie realizata
prin functia find_decoded) din string si se gaseste substringul "force" in sir.


	***************************************
        *               END README              *
        *                                       *
        *       Nume proiect: Tema 2 Iocla      *
        *       Autor: Diana Cretu      	*
        *       Grupa: 322 CC                   *
        *       Deadline: Joi, 07.12.2017	*
        *                                       *
        *                                       *
        ***************************************
