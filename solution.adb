with p_fenbase; use p_fenbase;
with Forms; use Forms;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with sequential_io;
use p_virus.p_coul_io;
use p_virus.p_piece_io;
use p_virus.p_dir_io;
with p_esiut; use p_esiut;
with text_io; use text_io;
with p_vue_graph; use p_vue_graph;

procedure solution is

GrilleSolution : TV_Grille;

PiecesSolution : TV_Pieces;

PSolution : boolean := true;

Solution : TR_Fenetre;

Bouton : String(1..3);

etape : natural := 0;

FicSolution : text_io.file_type; 
-------------------------------------------------
SizeX, SizeY : natural := 650;
Defi : p_virus.p_piece_io.file_type;
TouteCouleur : T_CoulGraph := (FL_RED,FL_DARKCYAN,FL_DARKORANGE,FL_DEEPPINK,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_GREEN,FL_YELLOW,FL_WHITE,FL_COL1);

-------------------------------------------------

begin

	InitialiserFenetres;

	open(Defi, in_file, "Defis.bin");
	open(FicSolution, in_file, "solution.txt");

	InitPartie(GrilleSolution, PiecesSolution);


	--


	Solution := DebutFenetre("Solution",SizeX,SizeY);

	AjouterBouton(Solution,"B12","Jeu",SizeX/2-50,SizeY-50,100,50); -- Pour le retour à la page jeu
	ChangerCouleurFond(Solution,"B12",FL_CHARTREUSE);

	AjouterBouton(Solution,"B13",">",SizeX/2+150,SizeY-200,50,50); -- Pour le retour à la page jeu
	ChangerCouleurFond(Solution,"B13",FL_CHARTREUSE);

	AjouterBouton(Solution,"B14","<",SizeX/2-200,SizeY-200,50,50); -- Pour le retour à la page jeu
	ChangerCouleurFond(Solution,"B14",FL_CHARTREUSE);

	AfficheGrille(Solution, GrilleSolution);
FinFenetre(Solution);
	
	
loop
	if PSolution then
		MontrerFenetre(Solution);

		-----------
		InitPartie(GrilleSolution, PiecesSolution);
		Configurer(Defi, 2, GrilleSolution, PiecesSolution);
		AjouterBouton(Solution,"A01","<",SizeX/2-200,SizeY,50,50); -- Pour le retour à la page jeu
		ChangerCouleurFond(Solution,"A01",FL_CHARTREUSE);
		AfficheGrille(Solution, GrilleSolution);
		-----------
		
		Bouton := AttendreBouton(Solution);
		if Bouton = "B12" then
			Psolution := false;
		end if;
		if Bouton = "B13" then
			etape := etape + 1;
		end if;
		if Bouton = "B14" then
			if etape > 0 then
				etape := etape - 1;
			end if;
		end if;
	end if;
	
	exit when not Psolution;
end loop;
end solution;
